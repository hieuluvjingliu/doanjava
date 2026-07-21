<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản Trị - Quý Bửu Store</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- FontAwesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        body { font-family: 'Inter', sans-serif; background-color: #f8f9fa; }
        .sidebar { height: 100vh; background-color: #343a40; color: white; padding-top: 20px;}
        .sidebar a { color: #cfd8dc; text-decoration: none; display: block; padding: 10px 20px; transition: 0.3s;}
        .sidebar a:hover { background-color: #495057; color: white; }
        .sidebar a.active { background-color: #0d6efd; color: white; }
        .content-area { padding: 30px; }
    </style>
</head>
<body>
<div class="container-fluid">
    <div class="row">
        <!-- Bắt đầu Sidebar -->
