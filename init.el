;; Use a separate file for custom.el

(setq custom-file (expand-file-name "custom.el" user-emacs-directory))

(when (file-exists-p custom-file)
  (load custom-file))

;; Theme and font
(load-theme 'modus-vivendi)
(set-face-attribute 'default nil :font "sf mono 13")

;; Adding melpa
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)

;; Keep Customize-generated settings out of init.el
