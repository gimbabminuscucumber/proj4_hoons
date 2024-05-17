<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ include file="../layout/header.jsp"%>

<section class="container">

    <!-- 왼쪽 섹션 -->
    <div class="section left">
        <br>
        <br>
        <div class="card m-2" style="width: 180px; height: 100px; background-image: url('/project4/images/bluesky.png'); background-size: cover; background-position: center;">
            <div class="card-body" style="height: 100%; width: 100%;"></div>
        </div>

        <div class="card m-2" style="width: 180px">
            <div class="list-group">
                <a href="#" class="list-group-item list-group-item-action">육류</a>
                <a href="#" class="list-group-item list-group-item-action">과일</a>
                <a href="#" class="list-group-item list-group-item-action">야채</a>
            </div>
        </div>
    </div>
    <!-- 왼쪽 섹션 종료 -->

    <!-- 중앙 섹션 -->
    <div class="section center">
        <!-- 검색창 -->
        <div class="m-2">
            <form class="form-inline d-flex justify-content-end" action="/project4/board">
                <input type="hidden" name="cmd" value="search" />
                <input type="hidden" name="page" value="0" />
                <input type="text" name="keyword" class="form-control mr-sm-2" placeholder="Search" style="width: 30%">
                <button class="btn btn-primary m-1">검색</button>
            </form>
        </div>


		<div class="card m-2">
			<div class="card-header">
				<i class="mtrl-select">모든 상품</i>
			</div>
		</div>

        <c:if test="${empty products}">
            <div>&nbsp; 등록된 상품이 없습니다.</div>
        </c:if>

        <div class="row">
            <c:forEach var="product" items="${products}" varStatus="status">
            	<input type="hidden" name="id" value="${product.id }">
                <div class="col-md-3">
                    <div class="card m-2">
                        <img src="${pageContext.request.contextPath}/images/productImg/${product.img}" alt="Product Image" style="width: 100%; height: auto;">
                        <div class="card-body">
                            <div class="d-flex">
	                            <div>
	                            	<h5><strong>${product.name}</strong></h5>
	                            </div>
                            	<div>
									<c:choose>
										<c:when test="${product.categoryId == 0}">&nbsp;l 육류</c:when>
										<c:when test="${product.categoryId == 1}">&nbsp;l 과일</c:when>
										<c:when test="${product.categoryId == 2}">&nbsp;l 야채</c:when>
									</c:choose>
                            	</div>
                           	</div>
                           	<p><strong><fmt:formatNumber type="number" pattern="#,##0"  value="${product.price}"/></strong>원</p>
                   			<div class="d-flex justify-content-end" >
	                        	<button type="button" class="btn btn-info btn-sm" style="height: 2rem;">수정</button>&nbsp;
	                        	<button type="button" class="btn btn-danger btn-sm" onclick="deleteById(${product.id})" style="height: 2rem;">삭제</button>
							</div>				                   			
                        </div>
                    </div>
                </div>

                <c:if test="${status.index % 5 == 4}">
                    </div><div class="row">
                </c:if>
            </c:forEach>
        </div>
    </div>
    <!-- 중앙 섹션 종료 -->

</section>

<script src="/project4/js/productInfo.js"></script>

<style>
.container {
    display: flex;
    /* justify-content: space-between; */
}

.section {
    padding: 10px;
    margin: 1px;
}

.section.left {
    flex: 1;
}

.section.center {
    flex: 9;
}
</style>
