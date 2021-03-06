;;; emacspeak/forms.el --- Speech friendly interface to /var/adm/messages
;;;$Id: messages.el 341 2001-07-21 02:04:51Z raman $
;;; $Author: raman $
;;; Description:  Emacspeak extension to speech enable sql-mode
;;; Keywords: forms
;;{{{  LCD Archive entry:

;;; LCD Archive Entry:
;;; emacspeak| T. V. Raman |raman@cs.cornell.edu
;;; A speech interface to Emacs |
;;; $Date: 2001-07-20 19:04:51 -0700 (Fri, 20 Jul 2001) $ |
;;;  $Revision: 341 $ |
;;; Location undetermined
;;;

;;}}}
;;{{{  Copyright:
;;;Copyright (C) 1995, 1996, 1997, 1998   T. V. Raman  
;;; Copyright (c) 1994, 1995 by Digital Equipment Corporation.
;;; All Rights Reserved.
;;;
;;; This file is not part of GNU Emacs, but the same permissions apply.
;;;
;;; GNU Emacs is free software; you can redistribute it and/or modify
;;; it under the terms of the GNU General Public License as published by
;;; the Free Software Foundation; either version 2, or (at your option)
;;; any later version.
;;;
;;; GNU Emacs is distributed in the hope that it will be useful,
;;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;;; GNU General Public License for more details.
;;;
;;; You should have received a copy of the GNU General Public License
;;; along with GNU Emacs; see the file COPYING.  If not, write to
;;; the Free Software Foundation, 675 Mass Ave, Cambridge, MA 02139, USA.

;;}}}
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;{{{  setup forms

(setq forms-read-only t)
(setq forms-file
      (read-file-name  "Messages file: "
                       "/var/adm/"
                       "/var/adm/messages"))


(setq forms-read-file-filter 'emacspeak-forms-flush-unwanted-records)
(setq forms-read-only nil)
(setq forms-field-sep
      (substring (system-name)
                 0
                 (string-match "\\." (system-name))))
(setq forms-number-of-fields 2)

(setq forms-format-list
      (list
       "Message: "2
       "\n"
       "Date: "1
       "\n"))

;;}}}

;;{{{ end of file

;;; local variables:
;;; folded-file: t
;;; byte-compile-dynamic: t
;;; end:

;;}}}
