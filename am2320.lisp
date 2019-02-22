
;; bytes-read
;; - n :: number of bytes to read
;; - str :: stream to read from
(defun br (n str)
  (when (< 0 n)
    (cons (read-byte str)
	  (br (1- n) str))))

;; get-temperature-humidity
(defun gth ()
  (with-i2c (str 92))
  (when (with-i2c (str 92)
	  (when str (dolist (b '(3 0 4) t)
		      (write-byte b str))))
    (with-i2c (str 92 8)
      (when str (let ((thd (br 8 str)))
		  (list
		   (/ (+ (ash (logand (nth 4 thd) 127) 8) (nth 5 thd)) 10)
		   (/ (+ (ash (nth 2 thd) 8) (nth 3 thd)) 10)))))))
