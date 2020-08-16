<%-- Mastan Swamy --%>

<title>Fund Transfer</title>

<%@ page import="java.sql.*" %>
<%
    // This if statement, is used to handle Fund Transfer Request in POST Method.
    if(request.getMethod().equals("POST"))
    {
        // registering the driver class
        Class.forName("com.mysql.jdbc.Driver");
        // establishing the connection
        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/MyBanking","scott","Masthan555!");

        Statement st = con.createStatement();
        PreparedStatement pst;
        ResultSet rs;


        // getting the from and to details from session and request.
        int from = (Integer) session.getAttribute("id");
        int to = Integer.valueOf(request.getParameter("to"));

        // checking whether the Recipient Exists in the User Database.
        pst = con.prepareStatement("select * from bank_users where accountno=?");
        pst.setInt(1,to);

        rs = pst.executeQuery();

        // if user exists, then continue the transaction
        if(rs.next())
        {
            // checking whether the sender has enough amount in his Account, and reducing his Account Balance
            int res1 = st.executeUpdate("update bank_users set balance=balance-1000 where accountno="+from+" and balance>=1000");

            // if the above statement executed, continue with the Remaining Transaction.
            if(res1==1)
            {
                // setting the Default Amount of 1000 rs as stated in mail.
                int cash = 1000;

                // Increasing the Account Balance of Receiver
                st.executeUpdate("update  bank_users set balance=balance+1000 where accountno="+to);

                // Inserting the transaction into the database
                st.executeUpdate("insert into bank_transactions(cash_from,cash_to,amount) values("+from+","+to+","+cash+")");

                con.close();
                response.sendRedirect("MainAccountScreen.jsp");
            }
            else
            {
                con.close();
                // if user don't have enough balance, alerting the Sender
                response.sendRedirect("MainAccountScreen.jsp?message=You don't have Enough Account Balance.");
            }
        }
        else
        {
            con.close();
            // If the Receiver Account Doesn't Exist in the Database, Alerting the Sender
            response.sendRedirect("MainAccountScreen.jsp?message=Account Number is Invalid.");
        }
    }
%>
