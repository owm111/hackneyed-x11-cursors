;; Copyright (C) Ludvig Hummel, Richard Ferreira
;; 
;; Permission is hereby granted, free of charge, to any person obtaining
;; a copy of this software and associated documentation files (the
;; "Software"), to deal in the Software without restriction, including
;; without limitation the rights to use, copy, modify, merge, publish,
;; distribute, sublicense, and/or sell copies of the Software, and to
;; permit persons to whom the Software is furnished to do so, subject to
;; the following conditions:
;; 
;; The above copyright notice and this permission notice shall be
;; included in all copies or substantial portions of the Software.
;; 
;; THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
;; EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
;; MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
;; NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR THE COPYRIGHT HOLDERS
;; BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
;; OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH
;; THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
;; 
;; Except as contained in this notice, the name(s) of the above copyright
;; holders shall not be used in advertising or otherwise to promote the sale,
;; use or other dealings in this Software without prior written authorization.

;; ----------------------------------------------------------------
;; Slightly modified version of the script found in
;; https://www.gimp.org/tutorials/Basic_Batch/
;; The point was to reduce the "jumpy" effect when switching cursors, but
;; the result is... not quite as smooth as I thought. I'll; leave the script
;; here for anyone interested. Seems to be a driver issue or whatever.

(define copyright "(C) Richard Ferreira")
(define license "MIT/X11")
(define comment "Hackneyed Xcursor theme")

(define (trim-cursor-files pattern)
	(let* ((filelist (cadr (file-glob pattern 1))))
		(while (not (null? filelist))
			(let* ((filename (car filelist))
				(image (car (file-xmc-load RUN-NONINTERACTIVE
					filename filename)))
				(drawable (car (gimp-image-get-active-layer image))))
				(file-xmc-save RUN-NONINTERACTIVE image drawable
					filename filename -1 -1 1 32 0 50 0
					copyright license comment)
				(gimp-image-delete image))
			(set! filelist (cdr filelist))))
	(gimp-quit 0))
