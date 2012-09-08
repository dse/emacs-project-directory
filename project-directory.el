;;; project-directory.el --- lets you invoke M-x compile from a deep subdirectory of the project directory

;; Copyright (C) 2012 Darren Embry

;; Author: Darren Embry <dse@webonastick.com>
;; Keywords: tools, processes

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; This will override any setting of the
;; `compilation-process-setup-function' variable.  I'll fix this as
;; soon as I can determine if there's a way to add compilation setup
;; hooks (which might be soon, might be never).

;;; Code:

(defun project-directory-find-file-upward (filename)
  "Looks for FILENAME in the current directory (as specified by
the `default-directory' variable) and then each parent directory
up to and including the root directory.

Returns the first instance of FILENAME found, or nil if no such
file is found.

This is primarily designed to allow you to invoke the `compile'
function from a deep subdirectory within a main project directory
containing, e.g., a Makefile."
  (let* ((dir      (expand-file-name default-directory))
	 (pathname (concat dir filename))
	 (parent   (file-name-directory (directory-file-name dir))))
    (cond
     ((file-readable-p pathname) pathname)
     ((string= parent dir) nil)
     (t (let ((default-directory parent))
	  (project-directory-find-file-upward filename))))))

(defun project-directory-find (filename)
  "Returns the project directory of the current directory (as
specified by the `default-directory' variable).

This is basically the directory containing the file whose name is
specified by the return value of the
`project-directory-find-file-upward' function.

This is primarily designed to allow you to invoke the `compile'
function from a deep subdirectory within a main project directory
containing, e.g., a Makefile."
  (let ((pathname (project-directory-find-file-upward filename)))
    (if pathname
	(file-name-directory pathname) nil)))

(defun project-directory-setup-function ()
  (cond
   ((string-match "^\\([/A-Za-z0-9\\+\\,\\-\\.\\:\\=\\@\\_\\~]*/\\)?make\\b"
		  compile-command)
    (let ((proj-dir (project-directory-find "Makefile")))
      (if proj-dir (setq default-directory proj-dir))))))

(setq compilation-process-setup-function 
      'project-directory-setup-function)

(provide 'project-directory)

;;; project-directory.el ends here
