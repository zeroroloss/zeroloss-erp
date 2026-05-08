// 공통 모달 팝업 관리

var commonModalCallback = null;

/**
 * 모달 초기화 (필요시 생성) - 함수 호출 전에 항상 실행
 */
function ensureModalInitialized() {
    // 모달이 이미 존재하면 반환
    if (document.getElementById('commonModalPopup')) {
        return;
    }
    
    // body가 없으면 대기 (이 경우는 드물지만 안전 장치)
    if (!document.body) {
        console.warn('body 요소가 없습니다. 초기화를 다시 시도하세요.');
        return;
    }
    
    // 모달 HTML 생성
    var modalHtml = '' +
        '<div id="commonModalPopup" class="common-modal-overlay">' +
        '  <div class="common-modal-content">' +
        '    <h1 class="common-modal-title" id="commonModalTitle">알림</h1>' +
        '    <p class="common-modal-message" id="commonModalMessage">메시지</p>' +
        '    <div class="common-modal-actions">' +
        '      <button type="button" class="common-modal-btn common-modal-btn-cancel" id="commonModalBtnCancel" onclick="commonCloseModal()" style="display:none;">취소</button>' +
        '      <button type="button" class="common-modal-btn common-modal-btn-ok" id="commonModalBtnOk" onclick="commonCloseModal()">확인</button>' +
        '    </div>' +
        '  </div>' +
        '</div>';
    
    document.body.insertAdjacentHTML('afterbegin', modalHtml);
    
    // 스타일 추가
    if (!document.getElementById('commonModalStyles')) {
        var styles = document.createElement('style');
        styles.id = 'commonModalStyles';
        styles.textContent = '' +
            '.common-modal-overlay {' +
            '  position: fixed;' +
            '  top: 0;' +
            '  left: 0;' +
            '  right: 0;' +
            '  bottom: 0;' +
            '  background: rgba(0, 0, 0, 0.5);' +
            '  display: none;' +
            '  align-items: center;' +
            '  justify-content: center;' +
            '  z-index: 99999;' +
            '}' +
            '.common-modal-overlay.show {' +
            '  display: flex;' +
            '}' +
            '.common-modal-content {' +
            '  background: #fff;' +
            '  border-radius: 12px;' +
            '  padding: 24px;' +
            '  max-width: 380px;' +
            '  width: calc(100% - 32px);' +
            '  box-shadow: 0 12px 30px rgba(0, 0, 0, 0.12);' +
            '}' +
            '.common-modal-title {' +
            '  margin: 0 0 12px;' +
            '  font-size: 18px;' +
            '  font-weight: 700;' +
            '  color: #111827;' +
            '}' +
            '.common-modal-message {' +
            '  margin: 0 0 20px;' +
            '  font-size: 14px;' +
            '  line-height: 1.5;' +
            '  color: #374151;' +
            '  white-space: pre-wrap;' +
            '  word-break: break-word;' +
            '}' +
            '.common-modal-actions {' +
            '  display: flex;' +
            '  justify-content: flex-end;' +
            '  gap: 8px;' +
            '}' +
            '.common-modal-btn {' +
            '  min-width: 72px;' +
            '  height: 38px;' +
            '  border: 0;' +
            '  border-radius: 8px;' +
            '  font-size: 14px;' +
            '  font-weight: 700;' +
            '  cursor: pointer;' +
            '}' +
            '.common-modal-btn-cancel {' +
            '  background: #e5e7eb;' +
            '  color: #111827;' +
            '}' +
            '.common-modal-btn-ok {' +
            '  background: #2563eb;' +
            '  color: #fff;' +
            '}' +
            '.common-modal-btn-ok:hover {' +
            '  background: #1d4ed8;' +
            '}' +
            '.common-modal-btn-cancel:hover {' +
            '  background: #d1d5db;' +
            '}';
        
        document.head.appendChild(styles);
    }
}

/**
 * 알림 팝업 표시
 * @param {string} title - 제목
 * @param {string} message - 메시지
 * @param {function} callback - 확인 버튼 클릭 시 콜백
 */
function commonShowAlert(title, message, callback) {
    ensureModalInitialized();
    
    document.getElementById('commonModalTitle').textContent = title || '알림';
    document.getElementById('commonModalMessage').textContent = message || '';
    document.getElementById('commonModalBtnCancel').style.display = 'none';
    document.getElementById('commonModalBtnOk').textContent = '확인';
    
    commonModalCallback = callback;
    document.getElementById('commonModalBtnOk').onclick = function() {
        commonCloseModal();
        if (commonModalCallback) {
            commonModalCallback();
            commonModalCallback = null;
        }
    };
    
    document.getElementById('commonModalPopup').classList.add('show');
}

/**
 * 확인 팝업 표시
 * @param {string} title - 제목
 * @param {string} message - 메시지
 * @param {function} onOk - 확인 버튼 클릭 시 콜백
 * @param {function} onCancel - 취소 버튼 클릭 시 콜백 (선택사항)
 */
function commonShowConfirm(title, message, onOk, onCancel) {
    ensureModalInitialized();
    
    document.getElementById('commonModalTitle').textContent = title || '확인';
    document.getElementById('commonModalMessage').textContent = message || '';
    document.getElementById('commonModalBtnCancel').style.display = 'inline-block';
    document.getElementById('commonModalBtnOk').textContent = '확인';
    
    document.getElementById('commonModalBtnOk').onclick = function() {
        commonCloseModal();
        if (onOk) {
            onOk();
        }
    };
    
    document.getElementById('commonModalBtnCancel').onclick = function() {
        commonCloseModal();
        if (onCancel) {
            onCancel();
        }
    };
    
    document.getElementById('commonModalPopup').classList.add('show');
}

/**
 * 모달 팝업 닫기
 */
function commonCloseModal() {
    var modal = document.getElementById('commonModalPopup');
    if (modal) {
        modal.classList.remove('show');
    }
}

// 초기화 - DOMContentLoaded 후에도 한 번 더 시도
if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', ensureModalInitialized);
} else {
    ensureModalInitialized();
}
