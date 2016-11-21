<%-- 
    Document   : dashboard
    Created on : Nov 2, 2016, 1:35:02 AM
    Author     : Vincent
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        
        <title>Admin Dashboard</title>
        <%@include file="/lib/bootstrap.html" %>
        <%@include file="/lib/banner.html" %>
        <%@ page import="java.util.*" %>
        <%@ page import="java.sql.*" %>
        <%@ page import="user.User" %>
        <%@ page import="user.Claim" %>
        <%@ page import="database.MemberDAO" %>
        <%@ page import="database.ClaimDAO" %>
    </head>
    <body>
        <div class="container">
            <%
                    String error = (String)session.getAttribute("error");
                    if(error!=null){
                        out.println("<div class=\"alert alert-danger\" role=\"alert\">");
                        out.println(error);
                        out.println("<button type=\"button\" class=\"close\" data-dismiss=\"alert\" aria-label=\"Close\">");
                         out.println("<span aria-hidden=\"true\">&times;</span>");
                        out.println("</button>");
                        out.println("</div>");
                    }
                    session.setAttribute("error", null);
                    
                    String success = (String)session.getAttribute("success");
                    if(success!=null){
                        out.println("<div class=\"alert alert-success\" role=\"alert\">");
                        out.println(success);
                        out.println("<button type=\"button\" class=\"close\" data-dismiss=\"alert\" aria-label=\"Close\">");
                         out.println("<span aria-hidden=\"true\">&times;</span>");
                        out.println("</button>");
                        out.println("</div>");
                    }
                    session.setAttribute("success", null);
                %>
            <div class="col-md-3 ">
                <div class="panel panel-default">
                    <div class="panel-heading" role="tab" id="headingOne">
                        <h4 class="panel-title">
                            <a role="button" data-toggle="collapse" data-parent="#accordion" href="#collapseOne" 
                               accesskey=""aria-expanded="true" aria-controls="collapseOne">
                                Filter
                            </a>
                        </h4>
                    </div>
                    <div id="collapseOne" class="panel-collapse collapse in" role="tabpanel" aria-labelledby="headingOne">
                        <div class="panel-body">
                            <form action="#" method="POST"><!--need servlet to update the list-->
                                <div class="checkbox">
                                    <label>
                                        <input type="checkbox" value="APPLIED">
                                        APPLIED
                                    </label>
                                </div>
                                <div class="checkbox">
                                    <label>
                                        <input type="checkbox" value="">
                                        APPROVED
                                    </label>
                                </div>
                                <div class="checkbox">
                                    <label>
                                        <input type="checkbox" value="">
                                        SUSPENDED
                                    </label>
                                </div>
                                <input type="submit" class="btn btn-success btn-block" value="Update"/>
                            </form>
                        </div>
                    </div>
                </div>
                <button type="button" class="btn btn-default btn-block" 
                        aria-label="Left Align" onClick="location.href='./LogoutServlet'">
                    <div class="col-md-1">
                        <span class="glyphicon glyphicon-off"></span> 
                    </div>
                    <div class="col-md-2 ">
                        LOG OUT
                    </div>
                </button>
            </div>
            <div class="col-md-9 ">
                <div>
                    <ul class="nav nav-tabs" role="tablist">
                        <li role="presentation" class="active">
                            <a href="#home" aria-controls="home" role="tab" data-toggle="tab">Home</a>
                        </li>
                        <li role="presentation">
                            <a href="#users" aria-controls="users" role="tab" data-toggle="tab">Users</a>
                        </li>
                        <li role="presentation">
                            <a href="#claims" aria-controls="claims" role="tab" data-toggle="tab">Claims</a>
                        </li>
                    </ul>
                    <div class="tab-content">
                        <div role="tabpanel" class="tab-pane active" id="home">
                            <div class="col-md-6">
                                <center>
                                <div class="panel panel-primary">
                                    <div class="panel-heading">
                                        <h3 class="panel-title">Total Members</h3>
                                    </div>
                                    <div class="panel-body">
                                        
                                        <%
                                            MemberDAO mem = new MemberDAO();
                                            List memlist = mem.getAllRecords();
                                            out.println("<h1 style=\"font-size:70px;\">"+memlist.size()+"</h1>");
                                        %>
                                    </div>
                                </div>
                                </center>
                            </div>
                            <div class="col-md-6">
                                <center>
                                <div class="panel panel-primary">
                                    <div class="panel-heading">
                                        <h3 class="panel-title">Total Claims</h3>
                                    </div>
                                    <div class="panel-body">
                                        <%
                                            ClaimDAO claimTotal = new ClaimDAO();
                                            double totalClaims = 0;
                                            try{
                                                List userClaims = claimTotal.getAllClaims();
                                                for(int i=0;i<userClaims.size();i++){
                                                    Claim amount = (Claim)userClaims.get(i);
                                                    totalClaims+=amount.getAmount();
                                                }
                                                session.setAttribute("amount", (totalClaims/userClaims.size()));
                                            }catch(SQLException se){
                                                out.println("value/database problem");
                                            }
                                            out.println("<h1>&#163;"+String.format("%.2f", totalClaims)+"</h1>");
                                        %>
                                        <form action="charge-members" method="POST">
                                            <button class="btn btn-primary btn-block">Charge Membership</button>
                                        </form>
                                    </div>
                                </div>
                                </center>
                            </div>
                        </div>
                        <div role="tabpanel" class="tab-pane" id="users">
                                <%
                                    out.println("<table class=\"table\" >");
                                    out.println("<tr>");
                                    out.println("<th>#</th>");
                                    out.println("<th>ID</th>");
                                    out.println("<th>Name</th>");
                                    out.println("<th>Address</th>");
                                    out.println("<th>DOB</th>");
                                    out.println("<th>DOR</th>");
                                    out.println("<th>Status</th>");
                                    out.println("<th>Balance</th>");
                                    out.println("</tr>");
                                    MemberDAO member = new MemberDAO();
                                    List list = member.getAllRecords();

                                    if(list.isEmpty()){
                                        out.println("<tr>");
                                        out.println("<td>No Records Found</td>");
                                        out.println("</tr>");
                                    }else{
                                        for(int i=0;i<list.size();i++){
                                            User user = (User)list.get(i);
                                            out.println("<tr>");
                                            out.println("<td>" + (i+1) + "</td>");
                                            out.println("<td>" + user.getID() + "</td>");
                                            out.println("<td>" + user.getFirstName() + " " + user.getLastName() + "</td>");
                                            out.println("<td>" + user.getAddress() + "</td>");
                                            out.println("<td>" + user.getDOB() + "</td>");
                                            out.println("<td>" + user.getDOR() + "</td>");
                                            out.println("<td>" + user.isUserValid()+ "</td>");
                                            out.println("<td>&#163;" + user.getBalance() + "</td>");
                                            out.println("</tr>");
                                        }
                                    }
                                    out.println("</table>");
                                %>
                        </div>
                        <div role="tabpanel" class="tab-pane" id="claims">
                            <%
                                    out.println("<table class=\"table\" >");
                                    out.println("<tr>");
                                    out.println("<th>#</th>");
                                    out.println("<th>ID</th>");
                                    out.println("<th>Date</th>");
                                    out.println("<th>Rationale</th>");
                                    out.println("<th>Status</th>");
                                    out.println("<th>Amount</th>");
                                    out.println("</tr>");
                                    ClaimDAO claimdao = new ClaimDAO();
                                    try{
                                        List claimlist = claimdao.getAllClaims();
                                        if(list.isEmpty()){
                                            out.println("<tr>");
                                            out.println("<td>No Records Found</td>");
                                            out.println("</tr>");
                                        }else{
                                            for(int i=0;i<claimlist.size();i++){
                                                Claim claim = (Claim)claimlist.get(i);
                                                out.println("<tr>");
                                                out.println("<td>" + (i+1) + "</td>");
                                                out.println("<td>" + claim.getMem_id() + "</td>");
                                                out.println("<td>" + claim.getDate() + "</td>");
                                                out.println("<td>" + claim.getRationale() + "</td>");
                                                out.println("<td>" + claim.getStatus() + "</td>");
                                                out.println("<td>" + claim.getAmount() + "</td>");
                                                out.println("</tr>");
                                            }
                                        }
                                    }catch(SQLException se){
                                        out.println("<tr>");
                                        out.println("<td>Database connection error.</td>");
                                        out.println("</tr>");
                                    }
                                    
                                    out.println("</table>");
                                %>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </body>
    <%@include file="/lib/footer.html" %>

</html>
