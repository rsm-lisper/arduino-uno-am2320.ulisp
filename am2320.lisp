
;; read-n-bytes
;; - n :: number of bytes to read
;; - str :: stream to read from
;; returns list of bytes
(defun rnb (n str)
  (when (< 0 n)
    (cons (read-byte str)
	  (rnb (1- n) str))))

;; write-bytes
;; - bts :: list of bytes to write
;; - str :: stream to write
;; returns original bts list
(defun wbs (bts str)
  (dolist (b bts bts)
    (write-byte b str)))

;; get-temperature-humidity
;; returns two element list (temp-C humid-%) on success or nil on error (no connection)
(defun gth ()
  (with-i2c (str #x5c))
  (when (with-i2c (str #x5c)
	  (when str (wbs '(#x03 #x00 #x04) str)))
    (with-i2c (str #x5c 8)
      (when str (let ((pck (rnb 8 str)))
		  (list
		   (/ (+ (ash (logand (nth 4 pck) #b01111111) 8) (nth 5 pck)) 10)
		   (/ (+ (ash (nth 2 pck) 8) (nth 3 pck)) 10)))))))
