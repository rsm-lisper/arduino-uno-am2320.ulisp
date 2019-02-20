
(defun rb (c str)
  (when (< 0 c)
    (cons (read-byte str)
	  (rb (1- c) str))))

(defun wi (re bdy)
  (with-i2c (str 92 re)
    (when str
      (eval bdy))))

(defun thr ()
  (with-i2c (str 92))
  (when (wi nil '(dolist (v '(3 0 4) t) (write-byte v str)))
    (wi 8 '(let ((da (rb 8 str)))
	     (list
	      (/ (+ (ash (logand (nth 4 da) 127) 8) (nth 5 da)) 10)
	      (/ (+ (ash (nth 2 da) 8) (nth 3 da)) 10))))))
