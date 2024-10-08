;;; init.el --- Prelude's configuration entry point.
;;
;; Copyright (c) 2011-2023 Bozhidar Batsov
;;
;; Author: Bozhidar Batsov <bozhidar@batsov.com>
;; URL: https://github.com/bbatsov/prelude
;; Version: 1.1.0
;; Keywords: convenience

;; This file is not part of GNU Emacs.

;;; Commentary:

;; This file simply sets up the default load path and requires
;; the various modules defined within Emacs Prelude.

;;; License:

;; This program is free software; you can redistribute it and/or
;; modify it under the terms of the GNU General Public License
;; as published by the Free Software Foundation; either version 3
;; of the License, or (at your option) any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to the
;; Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
;; Boston, MA 02110-1301, USA.

;;; Code:

;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
                                        ;(package-initialize)

(defvar prelude-user
  (getenv
   (if (equal system-type 'windows-nt) "USERNAME" "USER")))

(message "[Prelude] Prelude is powering up... Be patient, Master %s!" prelude-user)

(when (version< emacs-version "25.1")
  (error "[Prelude] Prelude requires GNU Emacs 25.1 or newer, but you're running %s" emacs-version))

;; Always load newest byte code
(setq display-line-numbers 'relative)

;; write config here

;; I search
(setq search-wrap-around t)
(setq load-prefer-newer t)

;; font
(set-frame-font "NanumGothicCoding-14")


;; Copy line down
(defun duplicate-line-down ()
  "Duplicate the current line and move the cursor to the new line."
  (interactive)
  (move-beginning-of-line 1)
  (kill-line)
  (yank)
  (newline)
  (yank))

(global-set-key (kbd "C-S-d") 'duplicate-line-down)


;; Remove open bracket hightlights
(setq sp-highlight-pair-overlay nil)
(setq-default line-spacing 5)

(defun xah-toggle-line-spacing ()
  "Toggle line spacing between no extra space to extra half line height.
URL `http://xahlee.info/emacs/emacs/emacs_toggle_line_spacing.html'
Version 2017-06-02"
  (interactive)
  (if line-spacing
      (setq line-spacing nil)
    (setq line-spacing 0.4))
  (redraw-frame (selected-frame)))


;; fiplr file searchq
(global-set-key (kbd "C-c C-f") 'fiplr-find-file)

;; set width to 80 column length if multiple window is open
(defun set-window-width (n)
  "Set the selected window's width."
  (adjust-window-trailing-edge (selected-window) (- n (window-width)) t))

(defun set-80-columns ()
  "Set the selected window to 80 columns."
  (interactive)
  (set-window-width 80))

;; Use this if 'menu-bar--display-line-number-mode is not none
(defun set-85-columns ()
  "Set the selected window's body width to 85 columsn"
  (interactive)
  (set-window-width 86))

(defun set-window-body-width (columns)
  "Set the selected window's body width to COLUMNS, excluding the menu
bar and other UI elements."
  (let* ((window (selected-window))
         (frame (selected-frame))
         (body-width (window-body-width window))
         (char-width (frame-char-width))
         (line-height (frame-char-height))
         (menu-bar-height (if (menu-bar-mode) (frame-parameter nil 'menu-bar-lines) 0))
         (line-number-width (if (bound-and-true-p display-line-numbers-mode)
                                (line-number-display-width) 0))
         (desired-width (* columns char-width))
         (current-width (frame-pixel-width))
         (total-width (+ desired-width line-number-width (* menu-bar-height line-height))))
    ;; Set the frame width to accommodate the desired body width
    (set-frame-width frame (/ total-width char-width))
    (set-frame-height frame (frame-height frame))))

(global-set-key (kbd "C-x ~") 'set-80-columns)

;; Multiple Cursor
(require 'multiple-cursors)
(global-set-key (kbd "C-S-c C-S-c") 'mc/edit-lines)
(global-set-key (kbd "C->")         'mc/mark-next-like-this)
(global-set-key (kbd "C-<")         'mc/mark-previous-like-this)
(global-set-key (kbd "C-c C-<")     'mc/mark-all-like-this)
(global-set-key (kbd "M-<mouse-1>") 'mc/add-cursor-on-click)


;; display fill indicator
(global-display-fill-column-indicator-mode 72)
(blink-cursor-mode 1)


;; Fill column at 72 character
(setq-default fill-column 72)

(add-hook 'prog-mode-hook #'auto-fill-mode)
(auto-fill-mode t)

(use-package adaptive-wrap
  :ensure t
  :hook (prog-mode . adaptive-wrap-prefix-mode))

;; set window length to 80 character
unifize-server/apps/api/resources/migrations/sql/


;; Define Prelude's directory structure
(defvar prelude-dir (file-name-directory load-file-name)
  "The root dir of the Emacs Prelude distribution.")
(defvar prelude-core-dir (expand-file-name "core" prelude-dir)
  "The home of Prelude's core functionality.")
(defvar prelude-modules-dir (expand-file-name  "modules" prelude-dir)
  "This directory houses all of the built-in Prelude modules.")
(defvar prelude-personal-dir (expand-file-name "personal" prelude-dir)
  "This directory is for your personal configuration.

Users of Emacs Prelude are encouraged to keep their personal configuration
changes in this directory.  All Emacs Lisp files there are loaded automatically
by Prelude.")
(defvar prelude-personal-preload-dir (expand-file-name "preload" prelude-personal-dir)
  "This directory is for your personal configuration, that you want loaded before Prelude.")
(defvar prelude-vendor-dir (expand-file-name "vendor" prelude-dir)
  "This directory houses packages that are not yet available in ELPA (or MELPA).")
(defvar prelude-savefile-dir (expand-file-name "savefile" user-emacs-directory)
  "This folder stores all the automatically generated save/history-files.")
(defvar prelude-modules-file (expand-file-name "prelude-modules.el" prelude-personal-dir)
  "This file contains a list of modules that will be loaded by Prelude.")

(unless (file-exists-p prelude-savefile-dir)
  (make-directory prelude-savefile-dir))

(defun prelude-add-subfolders-to-load-path (parent-dir)
  "Add all level PARENT-DIR subdirs to the `load-path'."
  (dolist (f (directory-files parent-dir))
    (let ((name (expand-file-name f parent-dir)))
      (when (and (file-directory-p name)
                 (not (string-prefix-p "." f)))
        (add-to-list 'load-path name)
        (prelude-add-subfolders-to-load-path name)))))

;; add Prelude's directories to Emacs's `load-path'
(add-to-list 'load-path prelude-core-dir)
(add-to-list 'load-path prelude-modules-dir)
(add-to-list 'load-path prelude-vendor-dir)
(prelude-add-subfolders-to-load-path prelude-vendor-dir)

;; reduce the frequency of garbage collection by making it happen on
;; each 50MB of allocated data (the default is on every 0.76MB)
(setq gc-cons-threshold 50000000)

;; warn when opening files bigger than 100MB
(setq large-file-warning-threshold 100000000)

;; preload the personal settings from `prelude-personal-preload-dir'
(when (file-exists-p prelude-personal-preload-dir)
  (message "[Prelude] Loading personal configuration files in %s..." prelude-personal-preload-dir)
  (mapc 'load (directory-files prelude-personal-preload-dir 't "^[^#\.].*el$")))

(message "[Prelude] Loading Prelude's core modules...")

;; load the core stuff
(require 'prelude-packages)
(require 'prelude-custom)  ;; Needs to be loaded before core, editor and ui
(require 'prelude-ui)
(require 'prelude-core)
(require 'prelude-mode)
(require 'prelude-editor)
(require 'prelude-global-keybindings)

;; macOS specific settings
(when (eq system-type 'darwin)
  (require 'prelude-macos))

;; Linux specific settings
(when (eq system-type 'gnu/linux)
  (require 'prelude-linux))

;; WSL specific setting
(when (and (eq system-type 'gnu/linux) (getenv "WSLENV"))
  (require 'prelude-wsl))

;; Windows specific settings
(when (eq system-type 'windows-nt)
  (require 'prelude-windows))

(message "[Prelude] Loading Prelude's additional modules...")

;; the modules
(if (file-exists-p prelude-modules-file)
    (load prelude-modules-file)
  (message "[Prelude] Missing personal modules file %s" prelude-modules-file)
  (message "[Prelude] Falling back to the bundled example file sample/prelude-modules.el")
  (message "[Prelude] You should copy this file to your personal configuration folder and tweak it to your liking")
  (load (expand-file-name "sample/prelude-modules.el" prelude-dir)))

;; config changes made through the customize UI will be stored here
(setq custom-file (expand-file-name "custom.el" prelude-personal-dir))

;; load the personal settings (this includes `custom-file')
(when (file-exists-p prelude-personal-dir)
  (message "[Prelude] Loading personal configuration files in %s..." prelude-personal-dir)
  (mapc 'load (delete
               prelude-modules-file
               (directory-files prelude-personal-dir 't "^[^#\.].*\\.el$"))))

(message "[Prelude] Prelude is ready to do thy bidding, Master %s!" prelude-user)

;; Patch security vulnerability in Emacs versions older than 25.3
(when (version< emacs-version "25.3")
  (with-eval-after-load "enriched"
    (defun enriched-decode-display-prop (start end &optional param)
      (list start end))))

(prelude-eval-after-init
 ;; greet the use with some useful tip
 (run-at-time 5 nil 'prelude-tip-of-the-day))

;;; init.el ends here
