;; == Google stuff ==

(if use-google-stuff
    (load-file (concat emacs-root "dot-google.el")))


;; == My stuff ==

;; Set up the keyboard so the delete key on both the regular keyboard
;; and the keypad delete the character under the cursor and to the right
;; under X, instead of the default, backspace behavior.
(global-set-key [delete] 'delete-char)
(global-set-key [kp-delete] 'delete-char)

;; Turn on font-lock mode
(global-font-lock-mode t)

;; When setting mark, highlight selection
(setq transient-mark-mode t)

;; Always end a file with a newline
(setq require-final-newline t)

;; Stop at the end of the file, not just add lines
(setq next-line-add-newlines nil)

(when window-system
  ;; enable wheelmouse support by default
  (mwheel-install)
  ;; use extended compound-text coding for X clipboard
  (set-selection-coding-system 'compound-text-with-extensions))

;; Paren match highlighting
(show-paren-mode t)

;; Whitespace highlighting
(add-hook 'font-lock-mode-hook 'show-ws-highlight-trailing-whitespace)

;; Enable CUA key bindings: C-z/x/c/v
(cua-mode t)

;; Fixing Cut and Paste under X
(setq x-select-enable-clipboard t)

;; Auto-scroll in *compilation* buffer
(setq compilation-scroll-output t)

;; Disable splash screen
(setq inhibit-splash-screen t)

;; Disable toolbar
(if (fboundp 'tool-bar-mode) (tool-bar-mode -1))

;; Disable default "kill emacs" binding. Usually I press it incidentally.
(global-unset-key "\C-x\C-c")

;; Don't use TAB for indenting
(setq-default indent-tabs-mode nil)

;; Highlight current line
(global-hl-line-mode 1)

;; Instead of 'yes or no' use 'y or n'
(fset 'yes-or-no-p 'y-or-n-p)

;; Show column number in mode line
(column-number-mode 1)

;; Don't unsplit windows on ESC ESC ESC
(defadvice keyboard-escape-quit (around my-keyboard-escape-quit activate)
  (flet ((one-window-p (&optional nomini all-frames) t)) ad-do-it))

;; Rebind buffers list to Ibuffer
(global-set-key (kbd "C-x C-b") 'ibuffer)

;; Mute sound
(setq bell-volume 0)
(setq sound-alist nil)

;; Show full path to file in frame title
(setq-default frame-title-format
              (list '((buffer-file-name
                       " %f"
                       (dired-directory
                        dired-directory
                        (revert-buffer-function " %b" ("%b - Dir:  " default-directory)))))))


;; Quit without annoying confirmation
(defadvice save-buffers-kill-emacs (around no-query-kill-emacs activate)
  "Prevent annoying \"Active processes exist\" query when you quit Emacs."
  (flet ((process-list ())) ad-do-it))

(defun generate-temp-dir-name (name)
  "Generate a name for a temporary dir"
  (if (eq system-type 'windows-nt)
      (concat (getenv "TEMP") "\\" name "\\")
      (if (eq system-type 'darwin)
          (concat "/Users/" (user-login-name) "/." name "/")
          (concat "/tmp/" name "/" (user-login-name) "/"))))

;; Save / restore desktop
(setq desktop-path (list (generate-temp-dir-name "emacs_desktop")))
(make-directory (car desktop-path) t)
(desktop-save-mode t)
(setq desktop-save t)
(setq desktop-restore-eager 10)

;; Put autosave files (ie #foo#) in one place, *not* scattered all over the
;; file system! (The make-autosave-file-name function is invoked to determine
;; the filename of an autosave file.)
(defvar autosave-dir nil)
(setq autosave-dir (generate-temp-dir-name "emacs_autosaves"))
(make-directory autosave-dir t)

(defun auto-save-file-name-p (filename)
  (string-match "^#.*#$" (file-name-nondirectory filename)))

(defun make-auto-save-file-name ()
  (concat autosave-dir
   (if buffer-file-name
      (concat "#" (file-name-nondirectory buffer-file-name) "#")
    (expand-file-name
     (concat "#%" (buffer-name) "#")))))

;; Put backup files (ie foo~) in one place too. (The backup-directory-alist
;; list contains regexp=>directory mappings; filenames matching a regexp are
;; backed up in the corresponding directory. Emacs will mkdir it if necessary.)
(defvar backup-dir (generate-temp-dir-name "emacs_backups"))
(setq backup-directory-alist (list (cons "." backup-dir)))


;; Always open .h files in c++-mode.
(add-to-list 'auto-mode-alist '("\\.h$" . c++-mode))

;; == Set up packages ==

(load-file (concat emacs-root "dot-packages.el"))


;; == Set up customizations ==

(setq custom-file (concat emacs-root "dot-custom.el"))
(load custom-file)


;; == Start up commands ==
(shell)
(server-start)


;; == Project stuff ==

(if (not (eq use-project nil))
    (load-file (concat emacs-root "project-" use-project ".el")))
