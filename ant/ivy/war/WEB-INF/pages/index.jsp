<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:url var="resources" value="/resources/theme1" scope="request" />

<html>
<head>
<link href="${resources}/css/core.css" rel="stylesheet">
</head>
<body>
<h1>Ant and Ivy Spring MVC demo Project</h1>
 
<p>Greeting Messages: ${message}</p>	
</body>
</html>
