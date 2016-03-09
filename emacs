;; Put autosave files (ie #foo#) and backup files (ie foo~) in ~/.emacs.d/.
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(auto-save-file-name-transforms (quote ((".*" "~/.emacs.d/autosaves/\\1" t))))
 '(backup-directory-alist (quote ((".*" . "~/.emacs.d/backups/"))))
 '(inhibit-startup-screen t)
 '(nxml-slash-auto-complete-flag t)
 '(sr-speedbar-right-side nil))

;; xml end tag
;; (global-set-key (kbd ">") 'nxml-balanced-close-start-tag-inline)

;; create the autosave dir if necessary, since emacs won't.
(make-directory "~/.emacs.d/autosaves/" t)

;; compile shortcut
(global-set-key (kbd "C-<f9>") 'compile)

;; complete closing braces
(add-to-list 'load-path "~/.emacs.d/lisp/")
(require 'autopair)
(autopair-global-mode)

;; MELPA
(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/"))
(package-initialize)
(unless package-archive-contents (package-refresh-contents))

;; Refactoring
;(require 'easymenu)
;(define-key prog-mode-map (kbd "C-<f6>") 'emr-show-refactor-menu)
;(global-set-key (kbd "C-<f6>") 'emr-show-refactor-menu)
;(add-hook 'prog-mode-hook 'emr-initialize)

;; Line cursor and custom window size when windowed
(when (display-graphic-p)
  (setq-default cursor-type 'bar))
(if (window-system) (set-frame-size (selected-frame) 100 30))

;; Octave mode for all .m
(setq auto-mode-alist
      (cons '("\\.m$" . octave-mode) auto-mode-alist))

;; Extra octave goodies :)
(add-hook 'octave-mode-hook
          (lambda ()
            (abbrev-mode 1)
            (auto-fill-mode 1)
            (if (eq window-system 'x)
                (font-lock-mode 1))))

;; Tell emacs where is your ciao lib dir
(add-to-list 'load-path "~/.emacs.d/ciao/")

;; load the packaged named ciao.
(load "ciao") ;; best not to include the ending “.el” or “.elc”


;; Ciao mode for all .pl
(setq auto-mode-alist
      (cons '("\\.pl$" . ciao-mode) auto-mode-alist))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; enable speedbar
(global-set-key (kbd "C-<f2>") 'sr-speedbar-toggle)

;; speedy window switching
(global-set-key (kbd "C-<left>") 'windmove-left)
(global-set-key (kbd "C-<right>") 'windmove-right)
(global-set-key (kbd "C-<up>") 'windmove-up)
(global-set-key (kbd "C-<down>") 'windmove-down)
