
;; temp-humid-sensor-address
(defvar tha (ash #xb8 -1))

;; read-n-bytes
;; - n :: number of bytes to read
;; - str :: stream to read from
(defun rnb (n str)
  (when (< 0 n)
    (cons (read-byte str)
	  (rnb (1- n) str))))

;; get-temperature-humidity
(defun gth ()
  (with-i2c (str tha))
  (when (with-i2c (str tha)
	  (when str (dolist (b '(#x03 #x00 #x04) t)
		      (write-byte b str))))
    (with-i2c (str tha 8)
      (when str (let ((pck (rnb 8 str)))
		  (list
		   (/ (+ (ash (logand (nth 4 pck) #b01111111) 8) (nth 5 pck)) 10)
		   (/ (+ (ash (nth 2 pck) 8) (nth 3 pck)) 10)))))))
