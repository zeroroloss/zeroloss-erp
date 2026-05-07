<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="dto.NotificationDTO" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>알림 확인 - ZERO LOSS</title>

    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <style>
        .modal-hidden {
            display: none !important;
            visibility: hidden !important;
            opacity: 0 !important;
            pointer-events: none !important;
        }

        .notification-item {
            transition: all 0.25s ease;
        }

        .notification-item:hover {
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.08);
        }

        .line-clamp-2 {
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
            overflow: hidden;
        }
    </style>
</head>

<body class="bg-gray-50">
<%@ include file="/branch/common/layout/sidebar.jsp" %>

<div class="lg:pl-72">
    <main class="p-6">
        <div class="space-y-6">

            <!-- 상단 제목 -->
            <div class="flex items-center justify-between">
                <div>
                    <h1 class="text-3xl font-bold text-gray-900">알림 확인</h1>
                    <p class="text-gray-500 mt-2">수신된 알림을 확인하고 읽음 처리할 수 있습니다.</p>
                </div>

                <button onclick="markAllAsRead()"
                        class="flex items-center gap-2 bg-[#00853D] text-white px-4 py-2 rounded-lg hover:bg-[#006B2F] transition-colors">
                    <i class="fas fa-check-double"></i>
                    <span>전체 읽음 처리</span>
                </button>
            </div>

            <!-- 통계 카드 -->
            <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
                <div class="bg-white rounded-lg border border-gray-200 p-5">
                    <div class="flex items-center justify-between">
                        <div>
                            <p class="text-sm text-gray-500">전체 알림</p>
                            <p id="totalNotif" class="text-2xl font-bold text-gray-900 mt-1">${totalNotif}</p>
                        </div>
                        <div class="w-12 h-12 bg-green-100 rounded-lg flex items-center justify-center">
                            <i class="fas fa-bell text-[#00853D] text-xl"></i>
                        </div>
                    </div>
                </div>

                <div class="bg-white rounded-lg border border-gray-200 p-5">
                    <div class="flex items-center justify-between">
                        <div>
                            <p class="text-sm text-gray-500">읽지 않은 알림</p>
                            <p id="isReadNotif" class="text-2xl font-bold text-red-600 mt-1">${isReadNotif}</p>
                        </div>
                        <div class="w-12 h-12 bg-red-100 rounded-lg flex items-center justify-center">
                            <i class="fas fa-envelope text-red-600 text-xl"></i>
                        </div>
                    </div>
                </div>

                <div class="bg-white rounded-lg border border-gray-200 p-5">
                    <div class="flex items-center justify-between">
                        <div>
                            <p class="text-sm text-gray-500">오늘 알림</p>
                            <p id="todayNotif" class="text-2xl font-bold text-blue-600 mt-1">${todayNotif}</p>
                        </div>
                        <div class="w-12 h-12 bg-blue-100 rounded-lg flex items-center justify-center">
                            <i class="fas fa-calendar-day text-blue-600 text-xl"></i>
                        </div>
                    </div>
                </div>
            </div>

            <!-- 검색 / 필터 -->
            <div class="bg-white rounded-lg border border-gray-200 p-6">
                <div class="flex flex-col lg:flex-row gap-4">
                    <div class="flex-1 relative">
                        <input type="text"
                               id="searchInput"
                               placeholder="알림 제목 또는 내용으로 검색..."
                               class="w-full pl-4 pr-10 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-[#00853D]"
                               onkeyup="filterNotifications()">

                        <button onclick="filterNotifications()"
                                class="absolute right-2 top-1/2 transform -translate-y-1/2 p-2 text-gray-400 hover:text-[#00853D]">
                            <i class="fas fa-search"></i>
                        </button>
                    </div>

                    <div class="flex gap-2 flex-wrap lg:flex-nowrap">
                        <button onclick="setStatusFilter('all')"
                                class="px-4 py-2 bg-[#00853D] text-white rounded-lg text-sm font-medium status-filter-btn"
                                data-status="all">전체</button>

                        <button onclick="setStatusFilter('unread')"
                                class="px-4 py-2 border border-gray-300 text-gray-700 rounded-lg text-sm hover:bg-gray-50 status-filter-btn"
                                data-status="unread">읽지 않음</button>

                        <button onclick="setStatusFilter('read')"
                                class="px-4 py-2 border border-gray-300 text-gray-700 rounded-lg text-sm hover:bg-gray-50 status-filter-btn"
                                data-status="read">읽음</button>
                    </div>
                </div>

                <div class="flex gap-2 flex-wrap mt-4">
                    <button onclick="setTypeFilter('all')"
                            class="px-4 py-2 bg-[#00853D] text-white rounded-lg text-sm font-medium type-filter-btn"
                            data-type="all">전체 유형</button>

                    <button onclick="setTypeFilter('재고')"
					        class="px-4 py-2 border border-gray-300 text-gray-700 rounded-lg text-sm hover:bg-gray-50 type-filter-btn"
					        data-type="재고">재고</button>
					
					<button onclick="setTypeFilter('발주')"
					        class="px-4 py-2 border border-gray-300 text-gray-700 rounded-lg text-sm hover:bg-gray-50 type-filter-btn"
					        data-type="발주">발주</button>
					
					<button onclick="setTypeFilter('스왑')"
					        class="px-4 py-2 border border-gray-300 text-gray-700 rounded-lg text-sm hover:bg-gray-50 type-filter-btn"
					        data-type="스왑">스왑</button>
					
					<button onclick="setTypeFilter('공지')"
					        class="px-4 py-2 border border-gray-300 text-gray-700 rounded-lg text-sm hover:bg-gray-50 type-filter-btn"
					        data-type="공지">공지</button>
					
					<button onclick="setTypeFilter('시스템')"
					        class="px-4 py-2 border border-gray-300 text-gray-700 rounded-lg text-sm hover:bg-gray-50 type-filter-btn"
					        data-type="시스템">시스템</button>
				</div>
			</div>

            <!-- 알림 리스트 -->
            <div id="notificationList" class="space-y-4"></div>

            <!-- 페이징 -->
            <div class="flex items-center justify-between">
                <button onclick="previousPage()"
                        class="flex items-center gap-2 px-4 py-2 border border-gray-300 rounded-lg text-gray-700 hover:bg-gray-50 disabled:opacity-50 disabled:cursor-not-allowed"
                        id="prevBtn">
                    <i class="fas fa-chevron-left"></i>
                    <span>이전</span>
                </button>

                <div class="text-gray-600">
                    <span id="pageInfo"></span>
                </div>

                <button onclick="nextPage()"
                        class="flex items-center gap-2 px-4 py-2 border border-gray-300 rounded-lg text-gray-700 hover:bg-gray-50 disabled:opacity-50 disabled:cursor-not-allowed"
                        id="nextBtn">
                    <span>다음</span>
                    <i class="fas fa-chevron-right"></i>
                </button>
            </div>

        </div>
    </main>
</div>

<!-- 상세 모달 -->
<div id="viewModal" class="fixed inset-0 bg-black bg-opacity-50 z-40 modal-hidden flex items-center justify-center p-4">
    <div class="bg-white rounded-lg max-w-2xl w-full max-h-[90vh] overflow-y-auto">

        <div class="sticky top-0 bg-white border-b border-gray-200 p-6 flex items-start justify-between">
            <div class="flex-1">
                <div class="flex items-center gap-2 mb-3">
                    <span id="viewNotificationType" class="inline-block px-3 py-1 rounded text-sm font-medium"></span>
                    <span id="viewNotificationStatus" class="inline-block px-3 py-1 rounded text-sm font-medium"></span>
                </div>

                <h2 id="viewNotificationTitle" class="text-2xl font-bold text-gray-900"></h2>

                <div class="flex items-center gap-4 text-sm text-gray-500 mt-4">
                    <span>
                        <i class="fas fa-calendar mr-1"></i>
                        <span id="viewNotificationDate"></span>
                    </span>
                </div>
            </div>

            <button onclick="closeViewModal()" class="text-gray-400 hover:text-gray-600">
                <i class="fas fa-times text-xl"></i>
            </button>
        </div>

        <div class="p-6">
            <p id="viewNotificationContent" class="whitespace-pre-wrap text-gray-700 leading-relaxed"></p>
        </div>

        <div class="border-t border-gray-200 p-6 flex justify-end gap-3">
            <button onclick="closeViewModal()"
                    class="px-4 py-2 border border-gray-300 rounded-lg text-gray-700 hover:bg-gray-50">
                닫기
            </button>

            <button id="markReadBtn"
                    onclick="markAsReadFromModal()"
                    class="px-4 py-2 bg-[#00853D] text-white rounded-lg hover:bg-[#006B2F]">
                읽음 처리
            </button>

            <button onclick="deleteNotificationFromModal()"
                    class="px-4 py-2 bg-red-600 text-white rounded-lg hover:bg-red-700">
                삭제
            </button>
        </div>
    </div>
</div>

<script>
    const ctx = "<%= request.getContextPath() %>";

    <%
		@SuppressWarnings("unchecked")
	    List<NotificationDTO> notificationList =
	        (List<NotificationDTO>) request.getAttribute("notificationList");
	%>
	let allNotifications = [
		<%
		    if (notificationList != null) {
		        for (int i = 0; i < notificationList.size(); i++) {
		            NotificationDTO n = notificationList.get(i);

		            String category = n.getCategory();
		            String typeName = "";

		            if ("INVENTORY".equals(category)) {
		                typeName = "재고";
		            } else if ("ORDER".equals(category)) {
		                typeName = "발주";
		            } else if ("SWAP".equals(category)) {
		                typeName = "스왑";
		            } else if ("BOARD".equals(category)) {
		                typeName = "공지";
		            } else if ("SYSTEM".equals(category)) {
		                typeName = "시스템";
		            } else {
		                typeName = category;
		            }

		            String title = n.getTitle() == null ? "" : n.getTitle().replace("\\", "\\\\").replace("'", "\\'").replace("\r", "").replace("\n", "\\n");
                    String message = n.getMessage() == null ? "" : n.getMessage().replaceAll("\\s*-\\s*\\d+\\s*수량:\\s*\\d+(\\.\\d+)?", "").replaceAll("\\(코드:\\s*\\d+\\)", "").replace("\\", "\\\\").replace("'", "\\'").replace("\r", "").replace("\n", "\\n");
		            String createdAt = n.getCreatedAt() == null ? "" : String.valueOf(n.getCreatedAt());
		%>
		    {
		        notificationId: <%= n.getNotificationId() %>,
		        title: '<%= title %>',
		        content: '<%= message %>',
		        type: '<%= typeName %>',
		        category: '<%= category %>',
		        isRead: <%= n.getIsRead() %>,
		        createdAt: '<%= createdAt %>'
		    }<%= (i < notificationList.size() - 1) ? "," : "" %>
		<%
		        }
		    }
		%>
		];
    let currentPage = 1;
    const itemsPerPage = 8;

    let currentStatusFilter = 'all';
    let currentTypeFilter = 'all';
    let selectedNotificationId = null;

    document.addEventListener('DOMContentLoaded', function () {
        initializeNotifications();
    });

    function initializeNotifications() {
        renderStats();
        renderNotifications();
    }

    function getTypeColor(type) {
        if (type === '재고') return 'bg-orange-100 text-orange-800';
        if (type === '발주') return 'bg-blue-100 text-blue-800';
        if (type === '스왑') return 'bg-green-100 text-green-800';
        if (type === '공지') return 'bg-red-100 text-red-800';
        if (type === '시스템') return 'bg-purple-100 text-purple-800';
        return 'bg-gray-100 text-gray-800';
    }

    function getStatusColor(isRead) {
        return isRead ? 'bg-gray-100 text-gray-600' : 'bg-red-100 text-red-700';
    }

    function getStatusText(isRead) {
        return isRead ? '읽음' : '읽지 않음';
    }

    function renderStats() {
        const total = allNotifications.length;
        const unread = allNotifications.filter(n => !n.isRead).length;

        const today = new Date().toISOString().substring(0, 10);
        const todayCount = allNotifications.filter(n => {
            if (!n.createdAt) return false;
            return n.createdAt.substring(0, 10) === today;
        }).length;

        document.getElementById('totalNotif').innerText = total;
        document.getElementById('isReadNotif').innerText = unread;
        document.getElementById('todayNotif').innerText = todayCount;
    }

    function filterAndSortNotifications() {
        const searchTerm = document.getElementById('searchInput').value.toLowerCase();

        const filtered = allNotifications.filter(notification => {
            const title = notification.title ? notification.title.toLowerCase() : '';
            const content = notification.content ? notification.content.toLowerCase() : '';

            const matchesSearch =
                title.includes(searchTerm) ||
                content.includes(searchTerm);

            const matchesStatus =
                currentStatusFilter === 'all' ||
                (currentStatusFilter === 'read' && notification.isRead) ||
                (currentStatusFilter === 'unread' && !notification.isRead);

            const matchesType =
                currentTypeFilter === 'all' ||
                notification.type === currentTypeFilter;

            return matchesSearch && matchesStatus && matchesType;
        });

        filtered.sort((a, b) => {
            if (!a.isRead && b.isRead) return -1;
            if (a.isRead && !b.isRead) return 1;
            return new Date(b.createdAt) - new Date(a.createdAt);
        });

        return filtered;
    }

    function renderNotifications() {
        const filtered = filterAndSortNotifications();
        const totalPages = Math.ceil(filtered.length / itemsPerPage);

        if (currentPage > totalPages) {
            currentPage = totalPages || 1;
        }

        const start = (currentPage - 1) * itemsPerPage;
        const currentNotifications = filtered.slice(start, start + itemsPerPage);

        const notificationList = document.getElementById('notificationList');

        if (currentNotifications.length === 0) {
            notificationList.innerHTML =
                '<div class="bg-white rounded-lg border border-gray-200 p-12 text-center">' +
                    '<i class="fas fa-bell-slash text-gray-300 text-4xl mb-4"></i>' +
                    '<p class="text-gray-500">조회된 알림이 없습니다.</p>' +
                '</div>';
        } else {
        	notificationList.innerHTML = currentNotifications.map(function(notification) {
        	    const typeClass = getTypeColor(notification.type);
        	    const statusClass = getStatusColor(notification.isRead);

        	    const readStyle = notification.isRead ? 'opacity-70' : '';
        	    const iconClass = notification.isRead ? 'fa-envelope-open text-gray-400' : 'fa-envelope text-red-500';

        	    return '' +
        	        '<div class="bg-white rounded-lg border border-gray-200 p-6 notification-item cursor-pointer hover:shadow-lg ' + readStyle + '"' +
        	        ' onclick="viewNotification(' + notification.notificationId + ')">' +

        	            '<div class="flex items-start gap-4">' +
        	                '<div class="w-11 h-11 rounded-full bg-gray-100 flex items-center justify-center flex-shrink-0">' +
        	                    '<i class="fas ' + iconClass + '"></i>' +
        	                '</div>' +

        	                '<div class="flex-1 space-y-2">' +
        	                    '<div class="flex items-center gap-2 flex-wrap">' +
        	                        '<span class="inline-block px-3 py-1 rounded text-sm font-medium ' + typeClass + '">' +
        	                            notification.type +
        	                        '</span>' +

        	                        '<span class="inline-block px-3 py-1 rounded text-sm font-medium ' + statusClass + '">' +
        	                            getStatusText(notification.isRead) +
        	                        '</span>' +

        	                        '<h3 class="font-bold text-lg text-gray-900">' +
        	                            notification.title +
        	                        '</h3>' +
        	                    '</div>' +

        	                    '<p class="text-gray-600 line-clamp-2">' +
        	                        notification.content +
        	                    '</p>' +

        	                    '<div class="flex items-center gap-4 text-sm text-gray-500">' +
        	                        '<span>' +
        	                            '<i class="fas fa-calendar mr-1"></i>' +
        	                            formatDate(notification.createdAt) +
        	                        '</span>' +
        	                    '</div>' +
        	                '</div>' +
        	            '</div>' +
        	        '</div>';
        	}).join('');
        }

        document.getElementById('prevBtn').disabled = currentPage === 1;
        document.getElementById('nextBtn').disabled = currentPage === totalPages || totalPages === 0;
        document.getElementById('pageInfo').innerText = (totalPages === 0 ? 0 : currentPage) + ' / ' + totalPages;
    }

    function formatDate(dateValue) {
        if (!dateValue) return '-';
        return new Date(dateValue).toLocaleString();
    }

    function filterNotifications() {
        currentPage = 1;
        renderNotifications();
    }

    function setStatusFilter(status) {
        currentStatusFilter = status;
        currentPage = 1;

        document.querySelectorAll('.status-filter-btn').forEach(btn => {
            const active = btn.dataset.status === status;

            btn.classList.toggle('bg-[#00853D]', active);
            btn.classList.toggle('text-white', active);
            btn.classList.toggle('border-gray-300', !active);
            btn.classList.toggle('text-gray-700', !active);
        });

        renderNotifications();
    }

    function setTypeFilter(type) {
        currentTypeFilter = type;
        currentPage = 1;

        document.querySelectorAll('.type-filter-btn').forEach(btn => {
            const active = btn.dataset.type === type;

            btn.classList.toggle('bg-[#00853D]', active);
            btn.classList.toggle('text-white', active);
            btn.classList.toggle('border-gray-300', !active);
            btn.classList.toggle('text-gray-700', !active);
        });

        renderNotifications();
    }

    function previousPage() {
        if (currentPage > 1) {
            currentPage--;
            renderNotifications();
            window.scrollTo(0, 0);
        }
    }

    function nextPage() {
        const totalPages = Math.ceil(filterAndSortNotifications().length / itemsPerPage);

        if (currentPage < totalPages) {
            currentPage++;
            renderNotifications();
            window.scrollTo(0, 0);
        }
    }

    async function viewNotification(notificationId) {
        const notification = allNotifications.find(n => n.notificationId === notificationId);
        if (!notification) return;

        selectedNotificationId = notificationId;

        document.getElementById('viewNotificationTitle').innerText = notification.title;
        document.getElementById('viewNotificationContent').innerText = notification.content;
        document.getElementById('viewNotificationDate').innerText = formatDate(notification.createdAt);

        const typeSpan = document.getElementById('viewNotificationType');
        typeSpan.className = 'inline-block px-3 py-1 rounded text-sm font-medium ' + getTypeColor(notification.type);
        typeSpan.innerText = notification.type;

        const statusSpan = document.getElementById('viewNotificationStatus');
        statusSpan.className = 'inline-block px-3 py-1 rounded text-sm font-medium ' + getStatusColor(notification.isRead);
        statusSpan.innerText = getStatusText(notification.isRead);

        const markReadBtn = document.getElementById('markReadBtn');
        markReadBtn.classList.toggle('hidden', notification.isRead);

        document.getElementById('viewModal').classList.remove('modal-hidden');
    }

    function closeViewModal() {
        document.getElementById('viewModal').classList.add('modal-hidden');
        selectedNotificationId = null;
    }

    async function markAsReadFromModal() {
        if (!selectedNotificationId) return;
        await markAsRead(selectedNotificationId);
        closeViewModal();
    }

    async function markAsRead(notificationId) {
        try {
            const response = await fetch(ctx + '/branch/common/notification?action=read&id=' + notificationId, {
                method: 'POST'
            });

            if (!response.ok) {
                throw new Error('읽음 처리 실패');
            }

            const notification = allNotifications.find(function(n) {
                return n.notificationId === notificationId;
            });

            if (notification) {
                notification.isRead = true;
            }
            
            if (typeof updateSidebarNotificationAfterRead === 'function') {
                updateSidebarNotificationAfterRead(notificationId);
            }

            renderStats();
            renderNotifications();

        } catch (error) {
            console.error(error);
            alert('읽음 처리 중 오류가 발생했습니다.');
        }
    }

    async function markAllAsRead() {
        if (!confirm('모든 알림을 읽음 처리하시겠습니까?')) return;

        try {
            const response = await fetch(ctx + '/branch/common/notification?action=readAll', {
                method: 'POST'
            });

            if (!response.ok) {
                throw new Error('전체 읽음 처리 실패');
            }

            allNotifications.forEach(function(n) {
                n.isRead = true;
            });
            
            if (typeof clearSidebarNotifications === 'function') {
                clearSidebarNotifications();
            }

            renderStats();
            renderNotifications();

        } catch (error) {
            console.error(error);
            alert('전체 읽음 처리 중 오류가 발생했습니다.');
        }
    }

    function deleteNotificationFromModal() {
        if (!selectedNotificationId) return;
        deleteNotification(selectedNotificationId);
    }

    async function deleteNotification(notificationId) {
        if (!confirm('이 알림을 삭제하시겠습니까?')) return;

        try {
            const response = await fetch(ctx + '/branch/common/notification?action=delete&id=' + notificationId, {
                method: 'POST'
            });

            if (!response.ok) {
                throw new Error('알림 삭제 실패');
            }

            allNotifications = allNotifications.filter(function(n) {
                return n.notificationId !== notificationId;
            });

            closeViewModal();
            renderStats();
            renderNotifications();

        } catch (error) {
            console.error(error);
            alert('알림 삭제 중 오류가 발생했습니다.');
        }
    }

    function toggleMenu(button) {
        const submenu = button.nextElementSibling;
        submenu.classList.toggle('hidden');

        const icon = button.querySelector('i.fa-chevron-right, i.fa-chevron-down');
        if (icon) {
            icon.classList.toggle('fa-chevron-right');
            icon.classList.toggle('fa-chevron-down');
        }
    }

    function toggleSidebar() {
        const sidebar = document.getElementById('sidebar');
        const backdrop = document.getElementById('sidebarBackdrop');

        sidebar.classList.toggle('-translate-x-full');
        backdrop.classList.toggle('hidden');

        backdrop.addEventListener('click', () => {
            sidebar.classList.add('-translate-x-full');
            backdrop.classList.add('hidden');
        });
    }
</script>
</body>
</html>