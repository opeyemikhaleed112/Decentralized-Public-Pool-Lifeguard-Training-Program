;; Certification Tracking Contract
;; Manages lifeguard certifications and renewal requirements

;; Constants
(define-constant CONTRACT-OWNER tx-sender)
(define-constant ERR-NOT-AUTHORIZED (err u100))
(define-constant ERR-ALREADY-CERTIFIED (err u101))
(define-constant ERR-NOT-FOUND (err u102))
(define-constant ERR-EXPIRED (err u103))
(define-constant ERR-INVALID-INPUT (err u104))

;; Data Variables
(define-data-var next-cert-id uint u1)

;; Data Maps
(define-map certifications
  { cert-id: uint }
  {
    lifeguard: principal,
    level: uint,
    issue-date: uint,
    expiry-date: uint,
    instructor: principal,
    status: (string-ascii 20)
  }
)

(define-map lifeguard-certs
  { lifeguard: principal }
  { cert-id: uint, active: bool }
)

(define-map authorized-instructors
  { instructor: principal }
  { authorized: bool, specializations: (list 10 (string-ascii 50)) }
)

;; Public Functions

;; Issue new certification
(define-public (issue-certification (lifeguard principal) (level uint) (expiry-blocks uint))
  (let (
    (cert-id (var-get next-cert-id))
    (current-block block-height)
    (expiry-date (+ current-block expiry-blocks))
  )
    (asserts! (is-authorized-instructor tx-sender) ERR-NOT-AUTHORIZED)
    (asserts! (and (>= level u1) (<= level u5)) ERR-INVALID-INPUT)
    (asserts! (> expiry-blocks u0) ERR-INVALID-INPUT)

    ;; Check if lifeguard already has active certification
    (match (map-get? lifeguard-certs { lifeguard: lifeguard })
      existing-cert (asserts! (not (get active existing-cert)) ERR-ALREADY-CERTIFIED)
      true
    )

    ;; Create certification record
    (map-set certifications
      { cert-id: cert-id }
      {
        lifeguard: lifeguard,
        level: level,
        issue-date: current-block,
        expiry-date: expiry-date,
        instructor: tx-sender,
        status: "active"
      }
    )

    ;; Update lifeguard certification mapping
    (map-set lifeguard-certs
      { lifeguard: lifeguard }
      { cert-id: cert-id, active: true }
    )

    ;; Increment cert ID counter
    (var-set next-cert-id (+ cert-id u1))

    (ok cert-id)
  )
)

;; Renew existing certification
(define-public (renew-certification (cert-id uint) (new-expiry-blocks uint))
  (let (
    (cert-data (unwrap! (map-get? certifications { cert-id: cert-id }) ERR-NOT-FOUND))
    (current-block block-height)
    (new-expiry (+ current-block new-expiry-blocks))
  )
    (asserts! (is-authorized-instructor tx-sender) ERR-NOT-AUTHORIZED)
    (asserts! (> new-expiry-blocks u0) ERR-INVALID-INPUT)

    ;; Update certification with new expiry
    (map-set certifications
      { cert-id: cert-id }
      (merge cert-data { expiry-date: new-expiry, status: "active" })
    )

    (ok true)
  )
)

;; Revoke certification
(define-public (revoke-certification (cert-id uint))
  (let (
    (cert-data (unwrap! (map-get? certifications { cert-id: cert-id }) ERR-NOT-FOUND))
  )
    (asserts! (is-authorized-instructor tx-sender) ERR-NOT-AUTHORIZED)

    ;; Update certification status
    (map-set certifications
      { cert-id: cert-id }
      (merge cert-data { status: "revoked" })
    )

    ;; Update lifeguard mapping
    (map-set lifeguard-certs
      { lifeguard: (get lifeguard cert-data) }
      { cert-id: cert-id, active: false }
    )

    (ok true)
  )
)

;; Add authorized instructor
(define-public (add-instructor (instructor principal) (specializations (list 10 (string-ascii 50))))
  (begin
    (asserts! (is-eq tx-sender CONTRACT-OWNER) ERR-NOT-AUTHORIZED)
    (map-set authorized-instructors
      { instructor: instructor }
      { authorized: true, specializations: specializations }
    )
    (ok true)
  )
)

;; Read-only Functions

;; Check if certification is valid
(define-read-only (is-certification-valid (cert-id uint))
  (match (map-get? certifications { cert-id: cert-id })
    cert-data
      (and
        (is-eq (get status cert-data) "active")
        (> (get expiry-date cert-data) block-height)
      )
    false
  )
)

;; Get certification details
(define-read-only (get-certification (cert-id uint))
  (map-get? certifications { cert-id: cert-id })
)

;; Get lifeguard's current certification
(define-read-only (get-lifeguard-certification (lifeguard principal))
  (match (map-get? lifeguard-certs { lifeguard: lifeguard })
    cert-info
      (if (get active cert-info)
        (map-get? certifications { cert-id: (get cert-id cert-info) })
        none
      )
    none
  )
)

;; Check if instructor is authorized
(define-read-only (is-authorized-instructor (instructor principal))
  (match (map-get? authorized-instructors { instructor: instructor })
    instructor-data (get authorized instructor-data)
    false
  )
)

;; Get instructor specializations
(define-read-only (get-instructor-specializations (instructor principal))
  (match (map-get? authorized-instructors { instructor: instructor })
    instructor-data (some (get specializations instructor-data))
    none
  )
)
