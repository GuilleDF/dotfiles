;;; init.el --- Emacs autostart file
;;; Commentary:
;;; Code:
;; Put autosave files (ie #foo#) and backup files (ie foo~) in ~/.emacs.d/.
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default default default italic underline success warning error])
 '(ansi-color-names-vector
   ["#2e3436" "#a40000" "#4e9a06" "#c4a000" "#204a87" "#5c3566" "#729fcf" "#eeeeec"])
 '(auto-save-file-name-transforms (quote ((".*" "~/.emacs.d/autosaves/\\1" t))))
 '(backup-directory-alist (quote ((".*" . "~/.emacs.d/backups/"))))
 '(custom-safe-themes
   (quote
    ("c4a784404a2a732ef86ee969ab94ec8b8033aee674cd20240b8addeba93e1612" default)))
 '(indent-tabs-mode nil)
 '(inhibit-startup-screen t)
 '(nxml-slash-auto-complete-flag t)
 '(sr-speedbar-right-side nil)
 '(whitespace-line-column 95))

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

;; Highlight matching parenthesis
(show-paren-mode 1)

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
(global-set-key (kbd "C-S-<left>") 'windmove-left)
(global-set-key (kbd "C-S-<right>") 'windmove-right)
(global-set-key (kbd "C-S-<up>") 'windmove-up)
(global-set-key (kbd "C-S-<down>") 'windmove-down)


;; Term shortcut
(defun open-term ()
  (interactive)
  (ansi-term "/usr/bin/zsh"))
(global-set-key (kbd "C-<f3>") 'open-term)

;; Remove scroll bars
(scroll-bar-mode -1)

;; Autocomplete for C/C++
(require 'company)
(require 'irony)
(add-to-list 'company-backends 'company-irony)
(add-hook 'c++-mode-hook 'irony-mode)
(add-hook 'c-mode-hook 'irony-mode)
(add-hook 'objc-mode-hook 'irony-mode)
(add-hook 'c++-mode-hook 'company-mode)
(add-hook 'c-mode-hook 'company-mode)
(add-hook 'objc-mode-hook 'company-mode)

;; Syntax checking
(global-flycheck-mode)
(require 'flycheck)
(add-hook 'flycheck-mode-hook #'flycheck-irony-setup)
(add-hook 'c++-mode-hook (lambda () (setq flycheck-gcc-language-standard "c++11")))

;; replace the `completion-at-point' and `complete-symbol' bindings in
;; irony-mode's buffers by irony-mode's function
(defun my-irony-mode-hook ()
  (define-key irony-mode-map [remap completion-at-point]
    'irony-completion-at-point-async)
  (define-key irony-mode-map [remap complete-symbol]
    'irony-completion-at-point-async))
(add-hook 'irony-mode-hook 'my-irony-mode-hook)
(add-hook 'irony-mode-hook 'irony-cdb-autosetup-compile-options)


;; ROS stuff
(defun ROS-c-mode-hook()
  (setq c-basic-offset 2)
  (setq indent-tabs-mode nil)
  (c-set-offset 'substatement-open 0)
  (c-set-offset 'innamespace 0)
  (c-set-offset 'case-label '+))
(add-hook 'c-mode-common-hook 'ROS-c-mode-hook)

;;; In order to get namespace indentation correct, .h files must be opened in C++ mode
(add-to-list 'auto-mode-alist '("\\.h$" . c++-mode))

;; Remove toolbar
(tool-bar-mode -1)

;; Prevent speedbar refresh
(require 'sr-speedbar)
(sr-speedbar-refresh-turn-off)
(setq speedbar-show-unknown-files t) ; show all files

;; Replace highlighted text in type
(delete-selection-mode 1)

;; Make zshrc be recognized as .zshrc
(add-to-list 'auto-mode-alist '("zshrc" . sh-mode))

;; Make .launch files be recognized as xml
(add-to-list 'auto-mode-alist '("\\.launch$" . nxml-mode))

;; Add yank-pop-forwards
(defun yank-pop-forwards (arg)
  (interactive "p")
  (yank-pop (- arg)))
(global-set-key "\M-Y" 'yank-pop-forwards) ; M-Y (Meta-Shift-Y)

;; Switch between camel cased & underscored
(require 'string-inflection)
(global-unset-key (kbd "C-q"))
(global-set-key (kbd "C-q C-u") 'string-inflection-all-cycle)

;; Quick buffer switching
(global-set-key (kbd "C-<tab>") 'mode-line-other-buffer)


;; Intellij-like text moving
(global-set-key (kbd "M-S-<up>") 'move-text-up)
(global-set-key (kbd "M-S-<down>") 'move-text-down)

;; Set theme
(load-theme (quote badwolf))

;; Set persistent highlighting
(require 'highlight)
(require 'evil-search-highlight-persist)
(global-evil-search-highlight-persist t)

;; Enable whitespace mode
(global-whitespace-mode)

;; Multiple cursor goodies
(require 'multiple-cursors)
(global-set-key (kbd "C-S-c") 'mc/mark-next-like-this)
(global-set-key (kbd "C-c C-m") 'mc/edit-lines)

(provide 'init)
;;; init.el ends here
