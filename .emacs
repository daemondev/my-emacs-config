;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;ELPA;;;;;;;;;;;;;;
  (load "package")
  (add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/"))
  (package-initialize)
;;;;;;;;;;;;;;;GLOBAL CONFIG;;;;;;;;;;;;;;;;;;

;;PATH
;;(setenv "PATH" (concat (getenv "PATH") ":/bin"))
(setq exec-path (append exec-path '("/bin")))
(setenv "PATH" (concat (getenv "PATH") ":/opt/local/bin:/opt/local/sbin:/usr/bin:/bin:/usr/local/bin:/usr/X11/bin:/usr/local/git/bin:/bin"))
(setq exec-path
       (append exec-path'(
                          "/bin"
                          "/usr/local/bin"
                          "/usr/bin"
                          "/opt/local/bin"
                          "/opt/local/sbin"
                          "/usr/bin"
                          "/usr/local/bin"
                          "/usr/local/git/bin"
                          "/usr/x11/bin"
                          )
       )
)
;;resize split screen
(global-set-key (kbd "C-x 4") 'balance-windows)

;;path of config file
(add-to-list 'load-path "~/.emacs.d/")
;;cua-mode
(cua-selection-mode 1)
;;scroll-left-right
(global-set-key (kbd "C-,") 'scroll-left)
(global-set-key (kbd "C-.") 'scroll-right)
;;undo
(global-set-key (kbd "C-/") 'undo)
(global-set-key (kbd "C-?") 'redo)
;;undo-tree
(require 'undo-tree)
(global-undo-tree-mode)
;; parent-hightlite
(show-paren-mode t)
(setq show-paren-highlihgt-openparen t)
(setq show-paren-style 'parenthesis)
;;tabs and space
;;(highlight-tabs)
;;(highlight-trailing-whitespace)
(setq-default c-basic-offset 4
                  tab-width 4
                  indent-tabs-mode nil
)
(add-hook 'find-file-hook
           (lambda () (if (not indent-tabs-mode)
                          (set (make-local-variable 'whitespace-action) '(auto-cleanup)))))
(add-hook 'before-save-hook
          'whitespace-write-file-hook nil t)
(global-set-key (kbd "C-x w") 'whitespace-mode)
;;session config
(require 'session)
(add-hook 'after-init-hook 'session-initialize)

;;sudo configure
(defun sudo-before-save-hook ()
  (set (make-local-variable 'sudo:file) (buffer-file-name))
  (when sudo:file
    (unless(file-writable-p sudo:file)
      (set (make-local-variable 'sudo:old-owner-uid) (nth 2 (file-attributes sudo:file)))
      (when (numberp sudo:old-owner-uid)
	(unless (= (user-uid) sudo:old-owner-uid)
	  (when (y-or-n-p
		 (format "File %s is owned by %s, save it with sudo? "
			 (file-name-nondirectory sudo:file)
			 (user-login-name sudo:old-owner-uid)))
	    (sudo-chown-file (int-to-string (user-uid)) (sudo-quoting sudo:file))
	    (add-hook 'after-save-hook
		      (lambda ()
			(sudo-chown-file (int-to-string sudo:old-owner-uid)
					 (sudo-quoting sudo:file))
			(if sudo-clear-password-always
			    (sudo-kill-password-timeout)))
		      nil   ;; not append
		      t	    ;; buffer local hook
		      )))))))


(add-hook 'before-save-hook 'sudo-before-save-hook)
;;utf-8
;; For my language code setting (UTF-8)
(setq current-language-environment "UTF-8")
(prefer-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-clipboard-coding-system 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-buffer-file-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(set-selection-coding-system 'utf-8)
(modify-coding-system-alist 'process "*" 'utf-8)
(setq default-process-coding-system '(utf-8 . utf-8))
(setq-default pathname-coding-system 'utf-8)
(set-file-name-coding-system 'utf-8) 
;;;;;;;;;;;;;;;;GUI CONFIG;;;;;;;;;;;;;;;;;;;
;;;ibuffer
;;;aux-line
(require 'aux-line)
(load-theme 'misterioso)
;;;;;;cursor 
(set-cursor-color "green")
(set-mouse-color "white")
;;color
(set-foreground-color "#F7FBF7")
;;(set-background-color "#ffffff")
;;(set-face-foreground 'highlight "white")
;;(set-face-background 'highlight "blue")
(set-face-foreground 'region "darkblue")
(set-face-background 'region "#89C6E5")
;;(set-face-foreground 'secondary-selection "skyblue")
;;(set-face-background 'secondary-selection "#F7FBF7")

;;auto fit frame
;;(require 'autofit-frame)
;;(add-hook 'after-make-frame-functions 'fit-frame)
;; switch frame
(global-set-key [C-tab] 'other-window)
;;;zone
;;(require 'zone-settings)
;;highlihgt-curr line
(global-hl-line-mode 1)
;;(column-highlight-mode 1)
(or (facep 'my-hl-line-face) (make-face 'my-hl-line-face))
(setq hl-line-face 'my-hl-line-face)
(face-spec-set 'my-hl-line-face '((t (
:background "#666"
:inverse-video nil
))))
(defun wcy-color-theme-adjust-hl-mode-face()
"interactive"
(let* ((color (x-color-values (face-attribute 'default :background))))
(if (null color)
(error "not support.")
(let ((my-color (mapcar
(lambda (x)
(let ((y (/ #XFFFF 4))
(delta #X18FF))
(cond
((< x (* y 1))
(+ x delta))
((< x (* y 2))
(+ x delta))
((< x (* y 3))
(- x delta))
(t
(- x delta)))))
color)))
(message "%S %S" color my-color)
(set-face-attribute
'my-hl-line-face nil
:background
(concat "#"
(mapconcat
(lambda (c) (format "%04X" c))
my-color
"")))))))
(wcy-color-theme-adjust-hl-mode-face)
;;nav and ack
(require 'nav)
(require 'ack)

;;scrolling
(setq scroll-margin 3
      scroll-step 1
      scroll-conservatively 10000)
(setq mouse-wheel-progressive-speed nil)

;; ---------------------------------------------
;; Page down/up move the point, not the screen.
;; In practice, this means that they can move the
;; point to the beginning or end of the buffer.
;; ---------------------------------------------
;;line-space
(setq-default line-spacing 1)
;;speedbar
(require 'sr-speedbar)
(global-set-key (kbd "M-s") 'sr-speedbar-toggle)
;;font
(set-face-attribute 'default nil :family "Monaco")
(set-face-attribute 'default nil :height 120)
(set-face-italic-p 'italic nil) ;; the italic font in Chinese can not display
;;Full screen mode
(global-set-key (kbd "M-RET") 'ns-toggle-fullscreen)
;;Show Col and Row number
 '(display-battery-mode t)
 '(display-time-mode t)
 (setq line-number-mode t)
;; (setq column-number-mode )
;; (set-face-background 'linum "#FFF6ED")
;; (set-face-background 'fringe "#FFF6ED")
;; ;; (global-font-lock-mode t)

;;;;;;;;;tab width
(setq global-sgml-basic-offset 4)
(setq global-font-lock-mode t)

;;set windows size
(if window-system
;;no scroll-bar
    (set-scroll-bar-mode nil)
  (setq default-frame-alist
        (append
         '( (top . 80)
            (left . 100)
            (width . 110)
            (height . 50))
         default-frame-alist))
  )

;;time mode
(display-time-mode 1)
(setq display-time-24hr-format t)
(setq display-time-interval 10)

;;no beep when error
(setq ring-bell-function 'ignore)

;;transient-mode
(transient-mark-mode 1)

;;set yes or no to y or n
(fset 'yes-or-no-p 'y-or-n-p)


(setq font-lock-maximum-decoration t)
(setq font-lock-global-modes '(not shell-mode text-mode))
(setq font-lock-verbose t)
(setq font-lock-maximum-size '((t . 1048576) (vm-mode . 5250000)))

;;show image
(setq auto-image-file-mode t)

(global-set-key (kbd"C-x C-Q") 'loop-alpha)
(setq alpha-list '((70 50) (95 75))) 0
(defun loop-alpha ()
    (interactive)
    (let ((h (car alpha-list)))
        ((lambda (a ab)
             (set-frame-parameter (selected-frame) 'alpha (list a ab))
             (add-to-list 'default-frame-alist (cons 'alpha (list a ab))))
         (car h) (car (cdr h)))
        (setq alpha-list (cdr (append alpha-list (list h))))))

;;tab-bar- mode
(require 'tabbar)
(tabbar-mode t)
(require 'tabbar-ruler)
(set-face-attribute 'tabbar-default nil
                    :family "Vera Sans YuanTi Mono"
                    :background "#0e0e0e"
                    :foreground "#ffffff"
                    :height 1.2
                    )
(set-face-attribute 'tabbar-button nil
                    :inherit 'tabbar-default
                    :box '(:line-width 1 :color "#0e0e0e")
                    )
(set-face-attribute 'tabbar-selected nil
                    :inherit 'tabbar-default
                    :foreground "#0e0e0e"
                    :background "#ffffff"
                    :box '(:line-width 1 :color "#0e0e0e")
                    ;; :overline "black"
                    ;; :underline "black"
                    :weight 'bold
                    )
(set-face-attribute 'tabbar-unselected nil
                    :inherit 'tabbar-default
                    :background "#0e0e0e"
                    :foreground "#ffffff"
                    :box '(:line-width 1 :color "#0e0e0e")
                    )
(global-set-key [(meta shift p)] 'tabbar-backward)
(global-set-key [(meta shift n)] 'tabbar-forward)


;;;;;;;;;;;;;;;WEB SERV CONFIG;;;;;;;;;;;;;;;

;;;W3M

(add-to-list 'load-path "~/.emacs.d/w3m/")
(require 'w3m-load)
(setq w3m-default-display-inline-images t)
(setq w3m-default-toggle-inline-images t)
(setq w3m-display-inline-image t)
(setq w3m-default-save-directory "~/.emacs.d/EmacsData/w3m/")
(setq w3m-command-arguments '("-cookie" "-F"))
(setq w3m-use-cookies t)
(setq w3m-home-page "http://www.douban.com")

;;evernote
(add-to-list 'load-path "~/.emacs.d/evernote-mode/")
(setq evernote-enml-formatter-command '("w3m" "-dump" "-I" "UTF8" "-O" "UTF8")) ; option
(require 'evernote-mode)
(global-set-key "\C-cec" 'evernote-create-note)
(global-set-key "\C-ceo" 'evernote-open-note)
(global-set-key "\C-ces" 'evernote-search-notes)
(global-set-key "\C-ceS" 'evernote-do-saved-search)
(global-set-key "\C-cew" 'evernote-write-note)
(global-set-key "\C-cep" 'evernote-post-region)
(global-set-key "\C-ceb" 'evernote-browser)

;;jabber
(setq jabber-account-list
      '(("ryankungs@gmail.com" 
         (:network-server . "talk.google.com")
         (:connection-type . ssl))))

;;;;;;;;;;;;;;;;TOOLs CONFIG;;;;;;;;;;;;;;;;;
;; pomodoro
(add-to-list 'load-path "~/.emacs.d/pomodoro.el/")
(require 'pomodoro) 
;;ecb
(require 'ecb-autoloads)
(require 'cedet)
;;(semantic-load-enable-code-helpers)
;;(semantic-mode)
(add-to-list 'load-path "~/.emacs.d/git-emacs/")
;;high light changed
;;(global-highlight-changes-mode t)
;;git-emacs
(require 'git-emacs)
(global-set-key (kbd "C-c d") 'git-diff-all-head)
;;auto-complete
(add-to-list 'load-path "~/.emacs.d/auto-complete/")

(require 'company)
(require 'auto-complete)
(require 'auto-complete-config)
(require 'ac-company)
(global-auto-complete-mode t)
(ac-company-define-source ac-source-company-xcode company-xcode)
;; setting objc-mode of ac-mode
(setq ac-modes (append ac-modes '(objc-mode)))
(define-key ac-complete-mode-map "\C-n" 'ac-next)
(define-key ac-complete-mode-map "\C-p" 'ac-previous)
(setq ac-auto-start 1)
(ac-set-trigger-key "TAB")
(setq ac-candidate-max 20)
(define-key ac-complete-mode-map "\M-/" 'ac-stop)
(define-key ac-complete-mode-map "\t" 'ac-complete)
(define-key ac-complete-mode-map "\r" nil)
;;YASnippnet
(add-to-list 'load-path "~/.emacs.d/yasnippet/")
(require 'yasnippet)
(yas/initialize)
(yas/load-directory "~/.emacs.d/yasnippet/snippets/")


;;erc config
(require 'erc)
(require 'erc-ring)
(require 'erc-services)
(require 'erc-fill)
(require 'erc-autoaway)
(require 'erc-log)
(erc-ring-enable)
(erc-log-enable)

(setq erc-nick "kongzhen")
(setq erc-away-nickname "kongzhen{away}")

(setq erc-server "irc.intra.douban.com")
(erc-services-mode 1)
(setq erc-prompt-for-nickserv-password nil)
(setq erc-fill-function 'erc-fill-static)
(setq erc-fill-static-center 15)

(setq erc-log-channels t
      erc-log-channels-directory "~/.emacs.d/erc"
      erc-log-insert-log-on-open nil
      erc-log-file-coding-system 'utf-8)

(setq erc-prompt (lambda ()
                   (if (and (boundp 'erc-default-recipients)
                            (erc-default-target))
                       (erc-propertize (concat (erc-default-target) ">")
                                       'read-only t
                                       'rear-nonsticky t
                                       'front-nonsticky t)
                     (erc-propertize (concat "ERC>")
                                     'read-only t
                                     'rear-nonsticky t
                                     'front-nonsticky t))))
;;itunes--
(require 'itunes)
(global-set-key (kbd "C-c 8") 'itunes-playpause)
(global-set-key (kbd "C-c 9") 'itunes-previous-track)
(global-set-key (kbd "C-c 0") 'itunes-next-track)

;;;;;;;;;;;;;;;;;;;SHELL CONFIG;;;;;;;;;;;;;;;;;

;;auto kill shell buffer
(add-hook 'shell-mode-hook 'wcy-shell-mode-hook-func)
(defun wcy-shell-mode-hook-func  ()
  (set-process-sentinel (get-buffer-process (current-buffer))
                            #'wcy-shell-mode-kill-bufcfer-on-exit)
      )
(defun wcy-shell-mode-kill-buffer-on-exit (process state)
  (message "%s" state)
  (if (or
       (string-match "exited abnormally with code.*" state)
       (string-match "finished" state))
      (kill-buffer (current-buffer))))


(global-set-key "\C-x\C-b" 'electric-buffer-list)
;;      n, p    move to up or down;
;;      s       save changed buffer;
;;      d       delete  buffer


;;shell3
(setq shell-file-name "/bin/bash")
;;(autoload 'ansi-color-for-comint-mode-on "ansi-color" nil t)
;;(add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on t)

;;mutiterm
(require 'multi-term)
(setq multi-term-program "/bin/bash")


;;ssh setting
(require 'tramp)
(setq tramp-default-method "ssh")
(setq password-cache-expiry nil)

;;LANGURAGES CONFIG

;;zen coding mode
(require 'zencoding-mode)
(add-hook 'sgml-mode-hook 'zencoding-mode)
;;javascript mode
(autoload 'js2-mode "js2" nil t)
(add-to-list 'auto-mode-alist '("\\.js$" . js-mode))

;;(add-to-list 'load-path "~/.emacs.d/jshint-mode")
;;(add-to-list 'load-path "~/.emacs.d/flymake-node-jshint")
;;(require 'flymake-node-jshint)
;;(setq flymake-node-jshint-config "~/emacs.d/jshintrc.json")
;;(add-hook 'js2-mode-hook
;;     (lambda () (flymake-mode 1)))
;;(add-hook 'js-mode-hook
;;     (lambda () (flymake-mode 1)))

;;css mode
(autoload 'css-mode "css-mode" "mode for editing css files" t)
(setq auto-mode-alist (append '(("\\.css$" . css-mode)) auto-mode-alist))

;;Python Mode
(setq load-path (cons "~/.emacs.d/python-mode/" load-path))
(setq auto-mode-alist (cons '("\\.py$" . python-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("\\.ptl$" . python-mode) auto-mode-alist))
;;(defadvice py-execute-buffer (after advice-delete-output-window activate)                                     
;;  (delete-windows-on "*Python Output*"))
;;pdb setup, note the python version
;;  (setq pdb-path '/System/Library/Frameworks/Python.framework/Versions/2.7/lib/python2.7/pdb.py
;; gud-pdb-command-name (symbol-name pdb-path))
;;  (defadvice pdb (before gud-query-cmdline activate)
;;    "Provide a better default command line when called interactively."
;;    (interactive
;;     (list (gud-query-cmdline pdb-path
;; 	 		    (file-name-nondirectory buffer-file-name)))))
;; ;
;;OBJC-mode
(add-to-list 'magic-mode-alist '("\\(.\\|\n\\)*\n@implementation" . objc-mode))
(add-to-list 'magic-mode-alist '("\\(.\\|\n\\)*\n@interface" . objc-mode))
(add-to-list 'magic-mode-alist '("\\(.\\|\n\\)*\n@protocol" . objc-mode))

;; hook
(add-hook 'objc-mode-hook
         (lambda ()
           (define-key objc-mode-map (kbd "\t") 'ac-complete)
           ;; xcode auto-complete
           (push 'ac-source-company-xcode ac-sources)
           ;; C++ auto-complete
           (push 'ac-source-c++-keywords ac-sources)
         ))

;;XCODE
(defun xcode:buildandrun ()
 (interactive)
 (do-applescript
  (format
   (concat
    "tell application \"Xcode\" to activate \r"
    "tell application \"System Events\" \r"
    "     tell process \"Xcode\" \r"
    "          key code 36 using {command down} \r"
    "    end tell \r"
    "end tell \r"
    ))))
(add-hook 'objc-mode-hook
         (lambda ()
           (define-key objc-mode-map (kbd "C-c C-r") 'xcode:buildandrun)
         ))

;;c
(add-hook 'c-mode-hook
          (lambda()
            (setq tab-width 4)
            (setq indent-tabs-mode nil)
            (setq sgml-basic-offset 4)))


;;html
(add-hook 'html-mode-hook
          (lambda()
            (setq tab-width 4)
            (setq indent-tabs-mode nil)
            (setq sgml-basic-offset 4)))

;;nxhtml
(add-to-list 'load-path "~/.emacs.d/nxhtml/util/")
(require 'css-color)
(require 'html-write)
(require 'sex-mode)
;;mmm-mode
(add-to-list 'load-path "~/.emacs.d/mmm-mode/")
(require 'mmm-auto)

;;mmm-mako-mode
(add-to-list 'load-path "~/.emacs.d/mmm-mako/")
(add-to-list 'auto-mode-alist '("\\.mako\\'" . html-mode))
(mmm-add-mode-ext-class 'html-mode "\\.mako\\'" 'mako)


;;Django
;;(add-to-list 'load-path "~/.emacs.d/django-mode/")
;;(require 'django-html-mode)
;;(require 'django-mode)
;;(yas/load-directory "~/.emacs.d/django-mode/snippets")
;;(add-to-list 'auto-mode-alist '("\.djhtml$" . django-html-mode))


;;hideshow Mode
(defun toggle-selective-display (column)
      (interactive "P")
      (set-selective-display
       (or column
           (unless selective-display
             (1+ (current-column))))))
(defun toggle-hiding (column)
  (interactive "P")
  (if hs-minor-mode
          (if (condition-case nil
                          (hs-toggle-hiding)
                        (error t))
                  (hs-show-all))
        (toggle-selective-display column)))

(global-set-key (kbd "C--") 'toggle-hiding)
(global-set-key (kbd "C-=") 'toggle-selective-display)
(autoload 'hideshowvis-enable "hideshowvis" "Highlight foldable regions")
(autoload 'hideshowvis-minor-mode
   "hideshowvis"
   "Will indicate regions foldable with hideshow in the fringe."
   'interactive)
(dolist (hook (list 'emacs-lisp-mode-hook
                     'c++-mode-hook
                     'python-mode-hook
                     'java-mode-hook
                     'javascript-mode-hook
                     'html-mode-hook
                     'js2-mode-hook
                     'css-mode-hook
))
(add-hook hook 'hideshowvis-enable)
;;(add-hook hook 'indent-hint-mode)
(add-hook hook 'hs-minor-mode)
(add-hook hook 'linum-mode)
)

(put 'scroll-left 'disabled nil)

;;no shart up message
(setq kill-emacs-query-function )

;;php mode
(require 'php-mode)
(add-hook 'php-mode-hook
'(lambda () (define-abbrev php-mode-abbrev-table "ex" "extends")))

;;Zork setting
(require 'malyon)


;;truncate line
(global-set-key (kbd "C-c a") 'toggle-truncate-lines)


;;flymake
;; (when (load "flymake" t)
;;   (defun flymake-pyflakes-init ()
;;     (let* ((temp-file (flymake-init-create-temp-buffer-copy
;;                        'flymake-create-temp-inplace))
;;            (local-file (file-relative-name
;;                         temp-file
;;                         (file-name-directory buffer-file-name))))
;;       (list "pyflakes" (list local-file))))
;;   (add-to-list 'flymake-allowed-file-name-masks
;;                '("\\.py\\'" flymake-pyflakes-init)))
;; (add-hook 'python-mode-hook 'flymake-mode)

;;makedown_mode
(autoload 'markdown-mode "markdown-mode.el"
        "Major mode for editing Markdown files" t)
     (setq auto-mode-alist
        (cons '("\\.mkd" . markdown-mode) auto-mode-alist))
;;CEDET
;;(setq semantic-default-submodes '(global-semantic-idle-scheduler-mode
;;                                  global-semanticdb-minor-mode
;;                                  global-semantic-idle-summary-mode
;;                                  global-semantic-mru-bookmark-mode))
;;(semantic-mode 1)





;;;;;;;;;;;;;;;;;;;HACK CONFIG;;;;;;;;;;;;;;

;;warning hack
;; Mumamo is making emacs 23.3 freak out:
(when (and (equal emacs-major-version 23)
           (equal emacs-minor-version 3))
  (eval-after-load "bytecomp"
    '(add-to-list 'byte-compile-not-obsolete-vars
                  'font-lock-beginning-of-syntax-function))
  ;; tramp-compat.el clobbers this variable!
  (eval-after-load "tramp-compat"
    '(add-to-list 'byte-compile-not-obsolete-vars
                  'font-lock-beginning-of-syntax-function)))


;;;;;;;;;;;;;;;;;;VIM EMUL;;;;;;;;;;;;;;;;;;;;;
;;evil-mode
;;(require 'evil)
;;(evil-mode 1)


;; ;;evil-numbers
;; (require 'evil-numbers)
;; (global-set-key (kbd "C-c +") 'evil-numbers/inc-at-pt)
;; (global-set-key (kbd "C-c +") 'evil-numbers/inc-at-pt)
;; (add-to-list 'evil-emacs-state-modes 'org-mode)


;vim mode
;;(setq viper-mode t)
;;(require 'viper)
;;(require 'vimpulse)

;;desktop-save-mode
(desktop-save-mode t)

;;;;;;;;;;;;input method;;;;;

;; EIM Input Method. Use C-\ to toggle input method.
(add-to-list 'load-path ".emacs.d/eim")
(require 'eim-extra)
(autoload 'eim-use-package "eim" "chinese-py")
(setq eim-use-tooltip nil)
(setq eim-punc-translate-p nil)         ; use English punctuation
(register-input-method
 "eim-py" "euc-cn" 'eim-use-package
 "拼音" "EIM Chinese Pinyin Input Method" "py.txt"
 'my-eim-py-activate-function)
(set-input-method "eim-py")             ; use Pinyin input method
(setq activate-input-method t)          ; active input method
(toggle-input-method nil)               ; default is turn off
(defun my-eim-py-activate-function ()
  (add-hook 'eim-active-hook
            (lambda ()
              (let ((map (eim-mode-map)))
                (define-key eim-mode-map "-" 'eim-previous-page)
                (define-key eim-mode-map "=" 'eim-next-page)))))


;;;;;;;SERVER
(server-force-delete)
(server-start)


;;;;;;emacs auto add config;;;;;;;
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(column-number-mode t)
 '(cua-mode t nil (cua-base))
 '(display-battery-mode t)
 '(display-time-mode t)
 '(ecb-source-path (quote ("~/Dev/")))
 '(erc-after-connect (quote (erc-autojoin-channels erc-nickserv-identify-on-connect erc-cmd-NICK)))
 '(erc-autojoin-channels-alist (quote (("irc.intra.douban.com" "#f2e" "#dev" "#gondor"))))
 '(erc-nick "kongzhen")
 '(jabber-account-list (quote (("ryankungs@gmail.com" (:network-server . "talk.google.com") (:connection-type . ssl)))))
 '(ns-alternate-modifier (quote alt))
 '(ns-command-modifier (quote meta))
 '(safe-local-variable-values (quote ((encoding . utf-8-unix))))
 '(session-use-package t nil (session))
 '(show-paren-mode t)
 '(size-indication-mode t)
 '(speedbar-use-images t)
 '(tool-bar-mode nil))


;;; Emacs/W3 Configuration
(add-to-list 'load-path "~/.emacs.d/w3/lisp/")
(require 'w3-auto "w3-auto")
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(cursor ((t (:background "light green"))))
 '(erc-default-face ((t (:foreground "brown3"))))
 '(erc-notice-face ((t (:foreground "DarkGoldenrod2" :weight bold))))
 '(jabber-chat-prompt-local ((t (:foreground "light green" :weight bold))))
 '(jabber-chat-text-foreign ((t (:foreground "gold2"))))
 '(jabber-roster-user-away ((t (:foreground "turquoise3" :slant italic :weight normal))))
 '(jabber-roster-user-online ((t (:foreground "dark orange" :slant normal :weight bold))))
 '(jabber-title-large ((t (:inherit variable-pitch :weight bold))))
 '(mode-line ((t (:background "dark cyan" :foreground "gray97"))))
 '(speedbar-directory-face ((t (:foreground "light blue"))))
 '(speedbar-file-face ((t (:foreground "light green")))))
;;










