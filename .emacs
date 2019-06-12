;; load emacs 24's package system. Add MELPA repository.

(require 'package)
(let* ((no-ssl (and (memq system-type '(windows-nt ms-dos))
                    (not (gnutls-available-p))))
       (proto (if no-ssl "http" "https")))
  (when no-ssl
    (warn "\
Your version of Emacs does not support SSL connections,
which is unsafe because it allows man-in-the-middle attacks.
There are two things you can do about this warning:
1. Install an Emacs version that does support SSL and be safe.
2. Remove this warning from your init file so you won't see it again."))
  ;; Comment/uncomment these two lines to enable/disable MELPA and MELPA Stable as desired
  (add-to-list 'package-archives (cons "melpa" (concat proto "://melpa.org/packages/")) t)
  ;;(add-to-list 'package-archives (cons "melpa-stable" (concat proto "://stable.melpa.org/packages/")) t)
  (when (< emacs-major-version 24)
    ;; For important compatibility libraries like cl-lib
    (add-to-list 'package-archives (cons "gnu" (concat proto "://elpa.gnu.org/packages/")))))
(package-initialize)

(package-initialize)

(when (>= emacs-major-version 24)
  (require 'package)
  (add-to-list
   'package-archives
   ;; '("melpa" . "http://stable.melpa.org/packages/") ; many packages won't show if using stable
   '("melpa" . "http://melpa.milkbox.net/packages/")
   t))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (circe-notifications bitlbee weechat solarized-theme twittering-mode slack w3m w3 exwm haskell-mode company-lean lean-mode slime request-deferred request racket-mode clippy fireplace spray speed-type parrot pacmacs gnugo xkcd minesweeper emms cyberpunk-2019-theme cyberpunk-theme latex-preview-pane restart-emacs symon magit markdown-mode use-package dumb-jump company-quickhelp company crux hungry-delete multiple-cursors lentic move-text goto-line-preview focus beacon dimmer switch-window god-mode))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; This allows me to just start up emacs and automatically load everything
(dolist (package package-selected-packages)
  (unless (package-installed-p package)
    (package-install package)))

(require 'use-package)

;; uninstall god-mode (or at least kill it for now)
;; and install other things instead from the awesome-emacs list
;; actually keep god mode, it might be more recognized in the future
;; (require 'god-mode)
;; (global-set-key (kbd "<escape>") 'god-mode-all)
;; (setq god-exempt-major-modes nil)
;; (setq god-exempt-predicates nil)

(require 'switch-window)
(global-set-key (kbd "C-x o") 'switch-window)
(global-set-key (kbd "C-x 1") 'switch-window-then-maximize)
(global-set-key (kbd "C-x 2") 'switch-window-then-split-below)
(global-set-key (kbd "C-x 3") 'switch-window-then-split-right)
(global-set-key (kbd "C-x 0") 'switch-window-then-delete)

(global-set-key (kbd "C-x 4 d") 'switch-window-then-dired)
(global-set-key (kbd "C-x 4 f") 'switch-window-then-find-file)
(global-set-key (kbd "C-x 4 m") 'switch-window-then-compose-mail)
(global-set-key (kbd "C-x 4 r") 'switch-window-then-find-file-read-only)

(global-set-key (kbd "C-x 4 C-f") 'switch-window-then-find-file)
(global-set-key (kbd "C-x 4 C-o") 'switch-window-then-display-buffer)

(global-set-key (kbd "C-x 4 0") 'switch-window-then-kill-buffer)

(setq switch-window-shortcut-style 'qwerty)

(require 'dimmer)
(dimmer-mode)

(require 'beacon)
(beacon-mode 1)

;; It dimmed surrounding text too much
;; Maybe in certain buffers or certain conditions?
;; Adding hooks shouldn't be that bad
(require 'focus)
;; (focus-mode 1)

(require 'goto-line-preview)
(global-set-key [remap goto-line] 'goto-line-preview)

(require 'move-text)
(move-text-default-bindings)

;; (require 'lentic)

(require 'multiple-cursors)
(global-set-key (kbd "C-s-c C-s-c") 'mc/edit-lines)
(global-set-key (kbd "C->") 'mc/mark-next-like-this)
(global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
(global-set-key (kbd "C-c C-<") 'mc/mark-all-like-this)

(require 'hungry-delete)

(unless (package-installed-p 'crux)
  (package-refresh-contents)
  (package-install 'crux))

;; TODO - Add crux keybinds (suggested ones listed ont the project README (https://github.com/bbatsov/crux))

(add-hook 'after-init-hook 'global-company-mode)
(company-quickhelp-mode)
(global-set-key (kbd "S-SPC") #'company-complete)

(dumb-jump-mode)

(use-package flycheck
  :ensure t
  :init (global-flycheck-mode))

(setq-default flycheck-disabled-checkers '(emacs-lisp-checkdoc))

(use-package markdown-mode
  :ensure t
  :mode (("README\\.md\\'" . gfm-mode)
	 ("\\.md\\'" . markdown-mode)
	 ("\\.markdown\\'" . markdown-mode))
  :init (setq markdown-command "multimarkdown"))

;; magit is also installed but no configurations are needed at the moment

(require 'symon)
(symon-mode)

;; restart-emacs is installed as well and also doesn't require any configuration

;; (latex-preview-pane-mode)
;; ^ this doesn't really work

;; both cyberpunk and cyberpunk-2019 are installed themes
;; Melpa didn't work for cyberpunk-2019 so I needed to wget it from Github
;; https://raw.githubusercontent.com/the-frey/cyberpunk-2019/master/cyberpunk-2019-theme.el
(add-to-list 'custom-theme-load-path "~/.emacs.d/themes/")
;; (load-theme `cyberpunk-2019 t)
;; (load-theme 'cyberpunk t)

(setq solarized-distinct-fringe-background t)
(setq solarized-high-contrast-mode-line t)
(load-theme 'solarized-light t)

(defun zone-choose (pgm)
  "Choose a PGM to run for `zone'."
  (interactive
   (list
    (completing-read
     "Program: "
     (mapcar 'symbol-name zone-programs))))
  (let ((zone-programs (list (intern pgm))))
    (zone)))

;; minesweeper is installed, doesn't work very well with the

;; xkcd is installed of course
(require 'xkcd)

;; go is installed here (also got gnugo for a gui)
(require 'gnugo)

(require 'pacmacs)

;; parrot mode seemed to good to not include
(require 'parrot)
(parrot-mode)

(require 'speed-type)

(require 'spray)

(require 'fireplace)

(require 'clippy)
(setq clippy-tip-show-function #'clippy-popup-tip-show)

;(add-hook 'racket-mode-hook #'racket-unicode-input-method-emable)
;(add-hook 'racket-repl-mode-hook #'racket-unicode-input-method-enable)

(require 'slime)
(load (expand-file-name "~/quicklisp/slime-helper.el"))
;; replace "sbcl" with the path to your implementation
(setq inferior-lisp-program "sbcl")

(require 'request)
(defun test-request ()
  (request
 "http://httpbin.org/get"
 :params '(("key" . "value") ("key2" . "value2"))
 :parser 'json-read
 :success (cl-function
           (lambda (&key data &allow-other-keys)
             (message "I sent: %S" (assoc-default 'args data))))))
(require 'exwm)
(require 'exwm-config)
(exwm-config-default)

(require 'exwm-randr)
(setq exwm-randr-workspace-monitor-plist '(0 "HDMI-1"))
(add-hook 'exwm-randr-screen-change-hook 
      (lambda ()
	(start-process-shell-command
	 "xrandr" nil "xrandr --output HDMI-1 --right-of eDP-1 --auto")))
(exwm-randr-enable)

(add-to-list 'load-path "~/.emacs.d/el-get/el-get")

; (el-get-bundle slack)
(use-package slack
  :commands (slack-start)
  :init
  (setq slack-buffer-emojify t) ;; if you want to enable emoji, default nil
  (setq slack-prefer-current-team t)
  :config
  (slack-register-team
   ;; secret keys and stuff deleted here
   :full-and-display-names t))

(use-package alert
  :commands (alert)
  :init
  (setq alert-default-style 'notifier))

(set-default-font "Input Sans")

(defun irc ()
  "Connect to IRC"
  (interactive)
  (circe "Bitlbee"))

;; circe is the proper irc client for connecting to Bitlbee
;; once connected (a GPG2 error may come up, feel free to ignore), connect to channel &bitlbee for bitlbee stuff
;; For Facebook related things - https://wiki.bitlbee.org/HowtoFacebookMQTT
