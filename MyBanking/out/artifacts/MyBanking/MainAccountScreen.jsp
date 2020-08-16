<%-- Masthan Swamy --%>

<%@ page import="java.sql.*" %>
<%@ page import="java.text.SimpleDateFormat" %>

<%
    // Taking the Default User as Initial Primary Key (10000), since there is no login page
    session.setAttribute("id",10000);
    int defaultUserId = (Integer) session.getAttribute("id");

    // registering the driver class
    Class.forName("com.mysql.jdbc.Driver");
    // establishing the connection
    Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/MyBanking","scott","Masthan555!");

    Statement st = con.createStatement();
    PreparedStatement pst;
    ResultSet rs;
%>

<html>
<head>

    <title>Account Page</title>

    <style>
        h2
        {
            font-family: Candara;
        }
        .sideHeading
        {
            text-align: center;
            margin-top: 35px;
            font-family: Bahnschrift;
        }
        table
        {
            margin-left: 15%;
            font-family: Bahnschrift;
        }
        td
        {
            text-align: center;
        }
        th
        {
            text-align: center;
            background-color: darkslateblue;
            opacity: 0.9;
            color : white;
        }
        tr pre
        {
            font-family: Bahnschrift;
            display: inline;
        }
        #fundTransfer
        {
            width: 15%;
            cursor: pointer;
            padding : 8px;
            color : white;
            margin-left: 75%;
            margin-top: 15px;
            border-radius: 5px;
            font-weight: bolder;
            background-color: firebrick;
        }
        #to
        {
            width : 35%;
            padding: 10px;
            margin: 20px auto auto 32%;
            border: 3px solid darkslateblue;
            border-radius: 5px;
            outline: none;
            display: none;
        }
        #inputMsg
        {
            color: darkred;
            display: none;
            margin: auto auto auto 40%;
            font-size: 0.9rem;
        }
    </style>

</head>
<body style="margin-top: 3%">

    <%
        // Querying the User Details.
        rs = st.executeQuery("select * from bank_users where accountno="+defaultUserId);
        while(rs.next())
        {
    %>
    <%-- setting user details --%>
    <h2 style="margin-left: 15%;color: green;">Hello, <span style="color: #3c3131"><% out.print(rs.getString("name")); %></span></h2>
    <h2 style="margin-left: 15%;color: green">Your Balance is : <span style="color: #3c3131"><% out.print(rs.getInt("balance")); %> rs</span></h2>
    <%
        }
    %>

    <h2 class="sideHeading">Previous Transactions</h2>
    <table width="75%">
        <tr>
            <th style="width: 25%">From (Acc no)</th>
            <th style="width: 20%">To (Acc no)</th>
            <th style="width: 20%">Cash</th>
            <th style="width: 35%">Transaction Date</th>
        </tr>
        <%
            // Querying the Previous Transactions.
            rs = st.executeQuery("select * from bank_transactions where cash_from="+defaultUserId+" or cash_to="+defaultUserId+" order by transaction_date desc limit 5");
            // This stat is used, Whether the Transactions available or not
            boolean stat = false;
            while(rs.next())
            {
        %>

        <%-- Setting the Transaction Details. --%>
        <tr>
            <td style="width: 25%"><% out.print(rs.getInt("cash_from")); %></td>
            <td style="width: 20%"><% out.print(rs.getInt("cash_to")); %></td>
            <td style="width: 20%"><% out.print(rs.getInt("amount")); %></td>
            <td style="width: 35%"><%
                // Displaying date in pretty Format
                Date dt = new Date(rs.getTimestamp("transaction_date").getTime());
                out.print("<pre>"+new SimpleDateFormat("dd-MM-yy    HH:mm:ss  a").format(dt)+"<pre>");
            %></td>
        </tr>
        <%
                // if transactions exist, This Stat Becomes true
                stat = true;
            }
        %>

        <%
            // if stat is false, Then there are no Transactions
            if(!stat)
            {
        %>
        <tr>
            <td colspan="4"><p>You Do not have any Previous Transactions</p></td>
        </tr>
        <%
            }

            con.close();
        %>

    </table>

    <button id="fundTransfer" style="margin-top: 25px">Fund Transfer</button>



<%-- This Form is used to send the Receiver Account no, to the Server in POST Method--%>
<%-- Data is sent to TransferProcess.jsp Page, And We Already had Written Code to handle this Request --%>
<form action="TransferProcess.jsp" method="post" id="transferForm">
    <input type="number" name="to" id="to" placeholder="Enter Account No. of the Recipient" required />
    <!-- Hint Message to User -->
    <p id="inputMsg" style="color: red;">Press Enter Key, After Typing Account Number.</p>
</form>

</body>

<script>
    // when the Fund Transfer Button is Clicked.
    document.getElementById("fundTransfer").onclick = function(){

            document.getElementById("to").style.display = "inline";
            document.getElementById("to").focus();
            document.getElementById("inputMsg").style.display = "block";
    };

    // checking and alerting user, if There is any Response back from TransferProcess.jsp
    let url = window.location.href;
    if(url.search("message")!==-1)
    {
        let vals = url.split("=");
        alert(decodeURI(vals[1]));
    }

</script>

</html>