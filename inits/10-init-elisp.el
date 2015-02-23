;; ------------------------------------------------------------------------
;; @ theme

(load-theme 'flatland-black t)
(enable-theme 'flatland-black)

;; line number
(set-face-attribute 'linum nil :foreground "#888888" :height 1.0)

;; ------------------------------------------------------------------------
;; @color

;; (set-foreground-color                                  "#ffffff") ; 文字色
;; (set-background-color                                  "#000000") ; 背景色
(set-cursor-color                                      "#FF6600") ; カーソル色
;; (set-face-background 'region                           "#CCFFFF") ; リージョン
;; (set-face-foreground 'mode-line                        "#ffffff") ; モードライン文字
;; (set-face-background 'mode-line                        "#00008B") ; モードライン背景
;; (set-face-foreground 'mode-line-inactive               "#000000") ; モードライン文字 (非アクティブ)
;; (set-face-background 'mode-line-inactive               "#ffffff") ; モードライン背景 (非アクティブ)
;; (set-face-foreground 'font-lock-comment-delimiter-face "#888888") ; コメントデリミタ
;; (set-face-foreground 'font-lock-comment-face           "#888888") ; コメント
;; (set-face-foreground 'font-lock-string-face            "#FFCC33") ; 文字列
;; (set-face-foreground 'font-lock-function-name-face     "#ffffff") ; 関数名
(set-face-foreground 'font-lock-keyword-face           "#9999FF") ; キーワード
;; (set-face-foreground 'font-lock-constant-face          "#b8d977") ; 定数 (this, self なども)
;; (set-face-foreground 'font-lock-variable-name-face     "#FFCC33") ; 変数
(set-face-foreground 'font-lock-type-face              "#FF9999") ; クラス
;; (set-face-foreground 'fringe                           "#666666") ; fringe (折り返し記号なでが出る部分)
;; (set-face-background 'fringe                           "#282828") ; fringe

;; カーソル位置のフェースを調べる関数
(defun describe-face-at-point ()
  "Return face used at point."
  (interactive)
  (message "%s" (get-char-property (point) 'face)))

;; 現在行をハイライト
;; (global-hl-line-mode t)
;; (set-face-background 'hl-line "#222244")

;; ------------------------------------------------------------------------
;; @ dired

(require 'dired)
;; wdired
(define-key dired-mode-map "r" 'wdired-change-to-wdired-mode)

;; ------------------------------------------------------------------------
;; @helm

(define-key global-map (kbd "C-:") 'helm-for-files)
(define-key global-map (kbd "M-x") 'helm-M-x)

;; https://github.com/ShingoFukuyama/helm-swoop

;; helm from https://github.com/emacs-helm/helm
(require 'helm)

;; Locate the helm-swoop folder to your path
(add-to-list 'load-path "~/.emacs.d/elisp/helm-swoop")
(require 'helm-swoop)

;; Change the keybinds to whatever you like :)
(global-set-key (kbd "M-i") 'helm-swoop)
(global-set-key (kbd "M-I") 'helm-swoop-back-to-last-point)
(global-set-key (kbd "C-c M-i") 'helm-multi-swoop)
(global-set-key (kbd "C-x M-i") 'helm-multi-swoop-all)

;; When doing isearch, hand the word over to helm-swoop
(define-key isearch-mode-map (kbd "M-i") 'helm-swoop-from-isearch)
;; From helm-swoop to helm-multi-swoop-all
(define-key helm-swoop-map (kbd "M-i") 'helm-multi-swoop-all-from-helm-swoop)
;; When doing evil-search, hand the word over to helm-swoop
;; (define-key evil-motion-state-map (kbd "M-i") 'helm-swoop-from-evil-search)

;; Save buffer when helm-multi-swoop-edit complete
(setq helm-multi-swoop-edit-save t)

;; If this value is t, split window inside the current window
(setq helm-swoop-split-with-multiple-windows nil)

;; Split direcion. 'split-window-vertically or 'split-window-horizontally
(setq helm-swoop-split-direction 'split-window-vertically)

;; If nil, you can slightly boost invoke speed in exchange for text color
(setq helm-swoop-speed-or-color nil)

;; ;; Go to the opposite side of line from the end or beginning of line
(setq helm-swoop-move-to-line-cycle t)

;; Optional face for line numbers
;; Face name is `helm-swoop-line-number-face`
(setq helm-swoop-use-line-number-face t)

;; ------------------------------------------------------------------------
;; @key binding

; C-l に略語展開・補完機能を割り当て
(define-key global-map (kbd "M-/") 'hippie-expand)

;; C-h をバックスペースに変更
(keyboard-translate ?\C-h ?\C-?)

;; フレームの移動
(global-set-key (kbd "C-t") 'next-multiframe-window)
(global-set-key (kbd "C-S-t") 'previous-multiframe-window)

;; インデント
(global-set-key (kbd "C-S-i") 'indent-region)

;; 行番号を指定して移動
(global-set-key "\M-g" 'goto-line)

;;; リージョンを削除できるように
(delete-selection-mode t)

;; 範囲指定していないとき、 C-w で前の単語を削除
(defadvice kill-region (around kill-word-or-kill-region activate)
  (if (and (interactive-p) transient-mark-mode (not mark-active))
      (backward-kill-word 1)
    ad-do-it))

;; minibuffer 用
(define-key minibuffer-local-completion-map "\C-w" 'backward-kill-word)

;; カーソル位置の単語を削除
(defun kill-word-at-point ()
  (interactive)
  (let ((char (char-to-string (char-after (point)))))
    (cond
     ((string= " " char) (delete-horizontal-space))
     ((string-match "[\t\n -@\[-`{-~]" char) (kill-word 1))
     (t (forward-char) (backward-word) (kill-word 1)))))
(global-set-key "\M-d" 'kill-word-at-point)

;; 行の複製
(defun duplicate-line-backward ()
  "Duplicate the current line backward."
  (interactive "*")
  (save-excursion
    (let ((contents
           (buffer-substring
            (line-beginning-position)
            (line-end-position))))
      (beginning-of-line)
      (insert contents ?\n)))
  (previous-line 1))

(defun duplicate-region-backward ()
  "If mark is active duplicates the region backward."
  (interactive "*")
  (if mark-active

      (let* (
             (deactivate-mark nil)
             (start (region-beginning))
             (end (region-end))
             (contents (buffer-substring
                        start
                        end)))
        (save-excursion
          (goto-char start)
          (insert contents))
        (goto-char end)
        (push-mark (+ end (- end start))))
    (error
     "Mark is not active. Region not duplicated.")))

(defun duplicate-line-forward ()
  "Duplicate the current line forward."
  (interactive "*")
  (save-excursion
    (let ((contents (buffer-substring
                     (line-beginning-position)
                     (line-end-position))))
      (end-of-line)
      (insert ?\n contents)))
  (next-line 1))

(defun duplicate-region-forward ()
  "If mark is active duplicates the region forward."
  (interactive "*")
  (if mark-active
      (let* (
             (deactivate-mark nil)
             (start (region-beginning))
             (end (region-end))
             (contents (buffer-substring
                        start
                        end)))
        (save-excursion
          (goto-char end)
          (insert contents))
        (goto-char start)
        (push-mark end)
        (exchange-point-and-mark))
    (error "Mark is not active. Region not duplicated.")))

(global-set-key (kbd "<C-M-up>") 'duplicate-line-backward)
(global-set-key (kbd "<C-M-down>") 'duplicate-line-forward)

;; moving the line like eclipse
(defun move-line (arg)
  (let ((col (current-column)))
    (save-excursion
      (forward-line)
      (transpose-lines arg))
    (when (> arg 0)
      (forward-line arg))
    (move-to-column col)))

(global-set-key (kbd "<M-up>") (lambda () (interactive) (move-line -1)))
(global-set-key (kbd "<M-down>") (lambda () (interactive) (move-line 1)))

;; ------------------------------------------------------------------------
;; @etc

(set-frame-parameter nil 'alpha 96)
(tool-bar-mode 0)
(scroll-bar-mode -1)
(menu-bar-mode 0)

;; 現在位置のファイル・ URL を開く
(ffap-bindings)

;; #* というバックアップファイルを作らない
(setq auto-save-default nil)

;; *.~ というバックアップファイルを作らない
(setq make-backup-files nil)

;; 現在位置のファイル・ URL を開く
(ffap-bindings)

;; ベルを鳴らさない
(setq ring-bell-function 'ignore)

;; redo
(require 'redo+)
(global-set-key (kbd "C-M-/") 'redo)
(setq undo-no-redo t)
(setq undo-limit 600000)
(setq undo-strong-limit 900000)

;; 略語展開・補完を行うコマンドをまとめる
(setq hippie-expand-try-functions-list
      '(try-complete-file-name-partially   ;ファイル名の一部
        try-complete-file-name             ;ファイル名全体
        try-expand-all-abbrevs             ;静的略語展開
        try-expand-dabbrev                 ;動的略語展開 (カレントバッファ)
        try-expand-dabbrev-all-buffers     ;動的略語展開 (全バッファ)
        try-expand-dabbrev-from-kill       ;動的略語展開 (キルリング:M-w/C-w の履歴)
        try-complete-lisp-symbol-partially ;Lisp シンボル名の一部
        try-complete-lisp-symbol           ;Lisp シンボル名全体
        ))

;; Indent
(setq-default tab-width 4)
(setq-default indent-tabs-mode nil)
(c-set-offset 'case-label '+)

;; C-k で改行を含め削除
(setq kill-whole-line t)

;; カーソル位置から行頭まで削除する
(defun backward-kill-line (arg)
  "Kill chars backward until encountering the end of a line."
  (interactive "p")
  (kill-line 0))
(global-set-key (kbd "C-S-k") 'backward-kill-line)

;; ファイルを自動保存する
;; M-x auto-install-from-url http://homepage3.nifty.com/oatu/emacs/archives/auto-save-buffers.el
(require 'auto-save-buffers)
(run-with-idle-timer 1 t 'auto-save-buffers) ; アイドル 1 秒で保存

;; タイトルバーに編集中のファイルのパス名を表示
(setq frame-title-format (format "emacs@%s : %%f" (system-name)))

;; 折り返さない (t で折り返さない, nil で折り返す)
(setq truncate-lines nil)
(setq truncate-partial-width-windows nil)

;; save-buffer 時、 buffer 末尾に空行が常にあるように
(setq require-final-newline t)

;; 選択している文字列を camelcase<->snakecase に変換するコマンド
;; link_to <-> linkTo のように相互変換される
;; http://d.hatena.ne.jp/IMAKADO/20091209/1260323922
(defun ik:decamelize (string)
  "Convert from CamelCaseString to camel_case_string."
  (let ((case-fold-search nil))
    (downcase
     (replace-regexp-in-string
      "\\([A-Z]+\\)\\([A-Z][a-z]\\)" "\\1_\\2"
      (replace-regexp-in-string
       "\\([a-z\\d]\\)\\([A-Z]\\)" "\\1_\\2"
       string)))))
(defun ik:camerize<->decamelize-on-region (s e)
  (interactive "r")
  (let ((buf-str (buffer-substring-no-properties s e))
        (case-fold-search nil))
    (cond
     ((string-match "_" buf-str)
      (let* ((los (mapcar 'capitalize (split-string buf-str "_" t)))
             (str (mapconcat 'identity los "")))
        ;; snake case to camel case
        (delete-region s e)
        (insert str)))
     (t
      (let* ((str (ik:decamelize buf-str)))
        ;; snake case to camel case
        (delete-region s e)
        (insert str))))))

;; paren-mode 対応する括弧を強調表示
(setq show-paren-delay 0)
(setq show-paren-style 'mixed)
(show-paren-mode t)
(set-face-background 'show-paren-match-face "#FF6600")
(set-face-foreground 'show-paren-mismatch-face "red")

;; yascroll
;; http://d.hatena.ne.jp/m2ym/
(require 'yascroll)
(global-yascroll-bar-mode 1)

;; ------------------------------------------------------------------------
;; @alias

(defalias 'qr  'query-replace)
(defalias 'qrr 'query-replace-regexp)
(defalias 'dtw 'delete-trailing-whitespace)
(defalias 'tab 'text-adjust-buffer)
(defalias 'tasb 'text-adjust-space-buffer)
(defalias 'icd 'insert-current-date)
(defalias 'ict 'insert-current-time)

;; ------------------------------------------------------------------------
;; @cua-mode

;; cua-mode をオン
(cua-mode t)

;; cua キーバインドを無効にする
(setq cua-enable-cua-keys nil)

;; ------------------------------------------------------------------------
;; @functions

;; http://d.hatena.ne.jp/kitokitoki/20100425/p1
(setq byte-compile-warnings '(free-vars unresolved callargs redefine obsolete noruntime cl-functions interactive-only make-local))

;; http://www.fan.gr.jp/~ring/doc/elisp_20/elisp_38.html#SEC609
;; 日付を挿入
(defun insert-current-date ()
  (interactive)
  (insert (format-time-string "%Y/%m/%d")))

;; 現在時刻を挿入
(defun insert-current-time ()
  (interactive)
  (insert (format-time-string "%Y%m%d%H%M%S")))

;; すべてのバッファを kill
(defun kill-all-buffers ()
  (interactive)
  (loop for buffer being the buffers
        do (kill-buffer buffer)))

;; ------------------------------------------------------------------------
;; @align

(require 'align)

;; Align for php-mode
;; http://d.hatena.ne.jp/Tetsujin/20070614/1181757931
(add-to-list 'align-rules-list
             '(php-assignment
               (regexp   . "[^-=!^&*+<>/.| \t\n]\\(\\s-*[.-=!^&*+<>/|]*\\)=>?\\(\\s-*\\)\\([^= \t\n]\\|$\\)")
               (justify  . t)
               (tab-stop . nil)
               (modes    . '(php-mode))))
(add-to-list 'align-dq-string-modes 'php-mode)
(add-to-list 'align-sq-string-modes 'php-mode)
(add-to-list 'align-open-comment-modes 'php-mode)
(setq align-region-separate (concat "\\(^\\s-*$\\)\\|"
                                    "\\([({}\\(/\*\\)]$\\)\\|"
                                    "\\(^\\s-*[)}\\(\*/\\)][,;]?$\\)\\|"
                                    "\\(^\\s-*\\(}\\|for\\|while\\|if\\|else\\|"
                                    "switch\\|case\\|break\\|continue\\|do\\) [ ;]\\)"
                                    ))

;; for ruby-mode
;; http://d.hatena.ne.jp/rubikitch/20080227/1204051280
(add-to-list 'align-rules-list
             '(ruby-comma-delimiter
               (regexp . ",\\(\\s-*\\) [^# \t\n]")
               (repeat . t)
               (modes  . '(ruby-mode))))
(add-to-list 'align-rules-list
             '(ruby-hash-literal
               (regexp . "\\(\\s-*\\)=>\\s-*[^# \t\n]")
               (repeat . t)
               (modes  . '(ruby-mode))))
(add-to-list 'align-rules-list
             '(ruby-assignment-literal
               (regexp . "\\(\\s-*\\)=\\s-*[^# \t\n]")
               (repeat . t)
               (modes  . '(ruby-mode))))
(add-to-list 'align-rules-list          ;TODO add to rcodetools.el
             '(ruby-xmpfilter-mark
               (regexp . "\\(\\s-*\\)# => [^#\t\n]")
               (repeat . nil)
               (modes  . '(ruby-mode))))

;; for cperl-mode
(add-to-list 'align-rules-list
             '(perl-assignment
               (regexp   . "[^-=!^&*+<>/.| \t\n]\\(\\s-*[.-=!^&*+<>/|]*\\)=>?\\(\\s-*\\)\\([^= \t\n]\\|$\\)")
               (justify  . t)
               (tab-stop . nil)
               (modes    . '(cperl-mode))))
(add-to-list 'align-dq-string-modes 'cperl-mode)
(add-to-list 'align-sq-string-modes 'cperl-mode)
(add-to-list 'align-open-comment-modes 'cperl-mode)
(setq align-region-separate (concat "\\(^\\s-*$\\)\\|"
                                    "\\( [({}\\[\\]\\(/\*\\)]$ \\)\\|"
                                    "\\(^\\s-*[)}\\(\*/\\)][,;]?$\\)\\|"
                                    "\\(^\\s-*\\(}\\|for\\|while\\|if\\|else\\|"
                                    "switch\\|case\\|break\\|continue\\|do\\) [ ;]\\)"
                                    ))

;; ------------------------------------------------------------------------
;; @utility

;; 終了前に確認する
(defadvice save-buffers-kill-emacs
  (before safe-save-buffers-kill-emacs activate)
  "safe-save-buffers-kill-emacs"
  (unless (y-or-n-p "Really exit emacs? ")
    (keyboard-quit)))

;; ------------------------------------------------------------------------
;; @text-adjust

;; http://d.hatena.ne.jp/rubikitch/20090220/text_adjust

;; 全角文字と半角文字の間に自動でスペースを開ける
;;
;; INSTALL
;; (install-elisp "http://taiyaki.org/elisp/text-adjust/src/text-adjust.el")
;; (install-elisp "http://taiyaki.org/elisp/mell/src/mell.el")

(require 'text-adjust)
;; (defun text-adjust-space-before-save-if-needed ()
;;   (when (memq major-mode
;;               '(org-mode text-mode mew-draft-mode myhatena-mode))
;;     (text-adjust-space-buffer)))
;;(add-hook 'before-save-hook 'text-adjust-space-before-save-if-needed)

;; ------------------------------------------------------------------------
;; @yasnippet

(require 'yasnippet)
(setq yas-snippet-dirs
      '("~/.emacs.d/snippets" "~/.emacs.d/plugins/yasnippet/snippets"))
(yas-global-mode 1) ;; or M-x yas-reload-all if you've started YASnippet already.

;; References
;; https://github.com/capitaomorte/yasnippet
;; http://yasnippet.googlecode.com/svn/trunk/doc/index.html
;; http://d.hatena.ne.jp/botchy/20080502/1209717204
;; http://yasnippet-doc-jp.googlecode.com/svn/trunk/doc-jp/index.html
;; http://sakito.jp/emacs/emacsobjectivec.html

;; ------------------------------------------------------------------------
;; @auto-complete

(when (require 'auto-complete-config nil t)
  ;; (define-key ac-mode-map (kbd "M-TAB") 'auto-complete)

  ;; 辞書補完
  ;; (add-to-list 'ac-dictionary-directories "~/.emacs.d/conf/ac-dict")

  ;; サンプル設定の有効化
  (ac-config-default)

  ;; 補完ウィンドウ内でのキー定義
  (define-key ac-completing-map (kbd "C-n") 'ac-next)
  (define-key ac-completing-map (kbd "C-p") 'ac-previous)
  (define-key ac-completing-map (kbd "M-/") 'ac-stop)

  ;; 補完が自動で起動するのを停止
  (setq ac-auto-start nil)

  ;; 起動キーの設定
  (ac-set-trigger-key "TAB")

  ;; 候補の最大件数 デフォルトは 10 件
  (setq ac-candidate-max 20)

  ;; 補完を開始する文字数
  (setq ac-auto-start 1)

  ;; 補完リストが表示されるまでの時間
  (setq ac-auto-show-menu 0.5)

  (defun auto-complete-init-sources ()
    (setq ac-sources '(ac-source-yasnippet
                       ac-source-dictionary
                       ac-source-gtags
                       ac-source-words-in-buffer)))

  (auto-complete-init-sources)

  (add-to-list 'ac-modes 'emacs-lisp-mode)
  (add-to-list 'ac-modes 'nxml-mode)
  (add-to-list 'ac-modes 'js2-mode)
  (add-to-list 'ac-modes 'tmt-mode)
  (add-to-list 'ac-modes 'yaml-mode)
  (add-to-list 'ac-modes 'sh-mode)
  (add-to-list 'ac-modes 'python-2-mode)

  ;; company
  ;; (install-elisp "http://nschum.de/src/emacs/company-mode/company-0.5.tar.bz2")

  ;; ac-company
  ;; (install-elisp "https://raw.github.com/buzztaiki/auto-complete/master/ac-company.el")
  (require 'ac-company)

  ;; ac-python
  ;; http://d.hatena.ne.jp/CortYuming/20111224/p1#
  (require 'ac-python)

  ;; for emacs-lisp-mode
  (add-hook 'emacs-lisp-mode-hook
            '(lambda ()
               (auto-complete-init-sources)
               (add-to-list 'ac-sources 'ac-source-functions)
               (add-to-list 'ac-sources 'ac-source-symbols))))

;; ------------------------------------------------------------------------
;; @auto-highlight-symbol

;; (auto-install-from-url "https://raw.github.com/mitsuo-saito/auto-highlight-symbol-mode/master/auto-highlight-symbol.el")
;; (auto-install-from-url "https://raw.github.com/mitsuo-saito/auto-highlight-symbol-mode/master/auto-highlight-symbol-config.el")
;; http://hiroki.jp/2011/01/25/1561/#more-1561
;; https://github.com/mitsuo-saito/auto-highlight-symbol-mode
;; Note:
;; 変数上にカーソルをおいて C-x C-a をタイプすることで、現在ハイライトされている変数の名前を全部一括して変更できる。
;; ただし、表示されていない部分は変更されないので注意する必要がある。

(when (require 'auto-highlight-symbol nil t)
(global-auto-highlight-symbol-mode t))

;; ------------------------------------------------------------------------
;; @Auto Indentation

;; http://emacswiki.org/emacs/AutoIndentation

(defun set-newline-and-indent ()
  (local-set-key (kbd "RET") 'newline-and-indent))

(add-hook 'lisp-mode-hook 'set-newline-and-indent)
(add-hook 'yaml-mode-hook 'set-newline-and-indent)
(add-hook 'js2-mode-hook 'set-newline-and-indent)
(add-hook 'cperl-mode-hook 'set-newline-and-indent)
(add-hook 'python-mode-hook 'set-newline-and-indent)
(add-hook 'ruby-mode-hook 'set-newline-and-indent)
(add-hook 'php-mode-hook 'set-newline-and-indent)
(add-hook 'nxml-mode-hook 'set-newline-and-indent)

;; ------------------------------------------------------------------------
;; @Auto Revert

;; http://yoshiori.github.com/blog/2013/01/31/file-update-emacs/
;; http://d.hatena.ne.jp/syohex/20130206/1360157000
;; http://d.hatena.ne.jp/tomoya/20100826/1282823932

;; 変更のあったファイルの自動再読み込み
(global-auto-revert-mode 1)
