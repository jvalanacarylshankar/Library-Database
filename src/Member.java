import java.sql.*;

public class Member implements User {
    private Statement statement;
    private ResultSet resultSet;
    private Connection connection;
    private int memberID;

    public Member(int userID) {
        connection = MainPage.connection;
        memberID = userID;
    }

    public void setMemberID(int userID) {
        memberID = userID;
    }

    /**
     * Updates the credit card associated with current memberID
     * @param creditCardNum
     * @returns true if update was successful
     */
    public ResultSet updateCreditCard(String creditCardNum) throws SQLException {
        try {
            if (creditCardNum.length() > 19) {
                System.out.println("Invalid credit card input.");
                return null;
            }
            statement = connection.createStatement();
            statement.executeQuery("UPDATE Member SET CreditCardNumber = " + creditCardNum +
                    " WHERE ID = " + memberID);
            resultSet = statement.executeQuery("SELECT * FROM Member WHERE ID = " + memberID);
            return resultSet;
        }
        catch (SQLException e) {
            System.out.println(e.getMessage());
        }
        return null;
    }

    /**
     *
     * @return the balance associated with the current memberID
     */
    public double viewMemberBalance() throws SQLException {
        try {
            statement = connection.createStatement();
            resultSet = statement.executeQuery("SELECT m.balance FROM Member m WHERE m.ID = " + memberID);
            if (resultSet.next()){
                return resultSet.getDouble("BALANCE");
            }
        }
        catch (SQLException e) {
            System.out.println(e.getMessage());
        }
        return 0;
    }

    /**
     * adds the given payment to the balance associated with the current memberID
     * assumed that balance is negative when owing money, positive when given extra from a payment
     *
     * @param payment
     * @return the new balance amount if payment was successful
     */
    public double payMemberBalance(String payment) throws SQLException {
        try {
            statement = connection.createStatement();
            double currentBalance = viewMemberBalance();
            currentBalance += Double.parseDouble(payment);
            //round to 2 decimal places
            currentBalance = (double) Math.round(currentBalance * 100) / 100;
            statement.executeUpdate("UPDATE Member SET Balance = " + currentBalance + " WHERE ID = " + memberID);
            return currentBalance;
        }
        catch (SQLException e) {
            System.out.println(e.getMessage());
        }
        return -999;
    }

    @Override
    public ResultSet seeUserInfo() throws SQLException {
        try {
            statement = connection.createStatement();
            resultSet = statement.executeQuery("SELECT * FROM (Users NATURAL JOIN Member) WHERE ID = " + memberID);
        }
        catch (SQLException e) {
            System.out.println(e.getMessage());
        }
        return resultSet;
    }

    @Override
    public ResultSet updateUserInfo(String name, String email, String phoneNumber, String address) throws SQLException {
        try {
            statement = connection.createStatement();
            statement.executeQuery("UPDATE USERS set NAME = '" +name+"', EMAIL = '"+email+"', PHONENUMBER = '" + phoneNumber+"', ADDRESS = '"+address +
                    "'where ID=" +memberID);
            System.out.println("Updated name: " + name + " email: " + email + " phoneNumber: " + phoneNumber + " address: " +address);
            resultSet = statement.executeQuery("SELECT * FROM Users WHERE ID = " + memberID);
            return resultSet;
        }
        catch (Exception e) {
            System.out.println(e.getMessage());
        }
        return null;
    }
}
