<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ include file="../layout/header.jsp"%>

<!-- 상단 배너 -->
<section class="container" style="width: 1100px">
	<div id="demo" class="carousel slide" data-ride="carousel" >
		<ul class="carousel-indicators">
			<li data-target="#demo" data-slide-to="0" class="active"></li>
			<li data-target="#demo" data-slide-to="1"></li>
			<li data-target="#demo" data-slide-to="2"></li>
		</ul>
		<div class="carousel-inner">
			<!-- 배너 1 -->
			<div class="carousel-item active">
				<img src="/project4/images/banner/포르미.png" alt="배너 1" width="1000" height="500">
				<div class="carousel-caption">
				</div>   
			</div>
			
			<!-- 배너 2 -->
			<div class="carousel-item">
			<img src="/project4/images/banner/카페인신현리.png" alt="배너 2" width="1000" height="500">
				<div class="carousel-caption">
				</div>   
			</div>
			
			<!-- 배너 3 -->
			<div class="carousel-item">
				<img src="/project4/images/banner/산양유프로틴.png" alt="배너 3" width="1000" height="500">
				<div class="carousel-caption">
				</div>   
			</div>
		</div>
	</div>
</section>

<section class="container">

    <!-- 왼쪽 섹션 -->
    <div class="section left">
        <br>
        <br>
		<div class="card m-2">
			<div class="card-header">
				<i class="mtrl-select">카테고리</i>
			</div>
		</div>
        <div class="card m-2" style="width: 180px">
            <div class="list-group">
            
               	<div class="list-group-item list-group-item-action d-flex">
               		<div><strong><a href="/project4/product?cmd=search&categoryId=0">정육</a></strong></div>
               		<div style="color:grey">&nbsp;meat</div>
               	</div>
               	<div class="list-group-item list-group-item-action d-flex">
               		<div><strong><a href="/project4/product?cmd=search&categoryId=1">과일</a></strong></div>
               		<div style="color:grey">&nbsp;fruit</div>
               	</div>
               	<div class="list-group-item list-group-item-action d-flex">
               		<div><strong><a href="/project4/product?cmd=search&categoryId=2">채소</a></strong></div>
               		<div style="color:grey">&nbsp;vegetable</div>
               	</div>
               	<div class="list-group-item list-group-item-action d-flex">
               		<div><strong><a href="/project4/product?cmd=search&categoryId=4">과자/간식</a></strong></div>
               		<div style="color:grey">&nbsp;snack</div>
               	</div>
               	<div class="list-group-item list-group-item-action d-flex">
               		<div><strong><a href="/project4/product?cmd=search&categoryId=5">밀키트</a></strong></div>
               		<div style="color:grey">&nbsp;mealkit</div>
               	</div>
            </div>
        </div>
    </div>
    <!-- 왼쪽 섹션 종료 -->

    <!-- 중앙 섹션 -->
    <div class="section center">
    
        <!-- 검색창 -->
        <div class="m-2">
            <form class="form-inline d-flex justify-content-end" action="/project4/product">
                <input type="hidden" name="cmd" value="search" />
                <input type="hidden" name="page" value="0" />
                <input type="text" name="keyword" class="form-control mr-sm-2" placeholder="Search" style="width: 30%">
                <button class="btn btn-primary m-1">검색</button>
            </form>
        </div>
		
		<!-- 상단 Nav -->
		<div class="card m-2">
			<div class="card-header">
				<c:choose>
					<c:when test="${empty param.keyword && empty param.categoryId }">
						<i class="mtrl-select">모든 상품</i>
					</c:when>
					<c:when test="${!empty param.keyword }">
						<i class="mtrl-select">'${param.keyword }' </i>로 검색한 결과
					</c:when>
					<c:when test="${!empty param.categoryId }">
						<i class="mtrl-select">'${param.categoryId }' </i>
							<c:choose>
								<c:when test="${param.categoryId == 0}">정육</c:when>
								<c:when test="${param.categoryId == 1}">과일</c:when>
								<c:when test="${param.categoryId == 2}">채소</c:when>
								<c:when test="${param.categoryId == 3}">과자/간식</c:when>
								<c:when test="${param.categoryId == 4}">밀키트</c:when>
							</c:choose>
					</c:when>
					<c:otherwise>
						
					</c:otherwise>
				</c:choose>
			</div>
		</div>
		
		<!-- 상품 리스트 -->
        <c:if test="${empty products}">
            <div>&nbsp; 등록된 상품이 없습니다.</div>
        </c:if>

        <div class="row">
            <c:forEach var="product" items="${products}" varStatus="status">
            	<input type="hidden" name="id" value="${product.id }">
                <div class="col-md-3">
                    <div class="card m-2">
                        <a href="/project4/product?cmd=detail&id=${product.id }">
                        	<img src="${pageContext.request.contextPath}/images/productImg/${product.img}" alt="Product Image" style="width: 100%; height: 152px;">
                        </a>
                        <div class="card-body">
							<c:choose>
								<c:when test="${product.categoryId == 0}">정육</c:when>
								<c:when test="${product.categoryId == 1}">과일</c:when>
								<c:when test="${product.categoryId == 2}">채소</c:when>
								<c:when test="${product.categoryId == 3}">과자/간식</c:when>
								<c:when test="${product.categoryId == 4}">밀키트</c:when>
							</c:choose>
                           	<h5><a href="/project4/product?cmd=detail&id=${product.id }"><strong>${product.brand}</strong></a></h5>
                       		<p><strong><fmt:formatNumber type="number" pattern="#,##0"  value="${product.price}"/></strong>원</p>
                   			<div class="d-flex justify-content-end" >
	                        	<button type="button" class="btn btn-info btn-sm" style="height: 2rem;">수정</button>&nbsp;
	                        	<button type="button" class="btn btn-danger btn-sm" onclick="deleteById(${product.id})" style="height: 2rem;">삭제</button>
							</div>				                   			
                        </div>
                    </div>
                </div>

                <c:if test="${status.index % 4 == 4}">
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

/*상단 배너*/
.carousel-inner img{
	width: 100%;
	height: 150px
}

</style>
