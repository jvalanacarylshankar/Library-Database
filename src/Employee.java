import java.sql.*;

public class Employee implements User {
    private Statement statement;
    private ResultSet resultSet;
    private Connection connection;
    private int employeeID;

    public Employee(int userID) {
        connection = MainPage.connection;
        employeeID = userID;
    }

    public void setEmployeeID(int employeeID) {
        this.employeeID = employeeID;
    }

    @Override
    public ResultSet seeUserInfo() throws SQLException {
        return seeUserInfo(employeeID);
    }

    /**
     * Returns the user tuple associated with given userID
     * @param userID
     * @return
     * @throws SQLException
     */
    public ResultSet seeUserInfo(int userID) throws SQLException {
        try {
            statement = connection.createStatement();
            resultSet = statement.executeQuery("SELECT * FROM Users WHERE ID = " + userID);
        }
        catch (SQLException e) {
            System.out.println(e.getMessage());
        }
        return resultSet;
    }

    @Override
    public ResultSet updateUserInfo(String name, String email, String phoneNumber, String address) throws SQLException {
        return updateUserInfo(employeeID, name, email, phoneNumber, address);
    }

    /** Updates any user's information given their ID, doesn't update field if given string is null
     * @param userID
     * @param email
     * @param phoneNum
     * @param address
     * @param name
     * @returns user resultset if update was successful
     * @throws SQLException
     */
    private ResultSet updateUserInfo(int userID, String name, String email, String phoneNum, String address) throws SQLException {
        try {
            statement = connection.createStatement();
            resultSet = statement.executeQuery("UPDATE USERS set EMAIL = '" +email+"', PHONENUMBER = '"+phoneNum+"', ADDRESS = '" + address+"', NAME = '"+name +
                    "'where ID=" +userID);
            System.out.println("Updated email: " + email + " phoneNum: " + phoneNum + " address: " + address + " name: " +name);
            resultSet = statement.executeQuery("SELECT * FROM Users WHERE ID = " + userID);
            return resultSet;
        }
        catch (Exception e) {
            System.out.println(e.getMessage());
        }
        return null;
    }

    /**
     * Deletes a particular copy of an item, given its ID and copyNumber
     *
     * @param itemID
     * @param copyNumber
     * @return true if deletion was sucesssful
     */
    public boolean deleteSingleCopyOfItem(String itemID, int copyNumber) throws SQLException {
        try {
            statement = connection.createStatement();
            resultSet = statement.executeQuery("DELETE from Status WHERE ItemID = " + itemID + " AND CopyNumber = " + copyNumber);
            return true;
        }
        catch (SQLException e) {
            System.out.println(e.getMessage());
        }
        return false;
    }

    /**
     * Deletes an item completely from the database. Status cascading means that all related copies should also be deleted
     * @param itemID
     * @return true if the deletion was successful
     */
    public boolean deleteItemCompletely(String itemID) throws SQLException {
        try {
            statement = connection.createStatement();
            resultSet = statement.executeQuery("DELETE from Item WHERE ItemID = " + itemID);
            return true;
        }
        catch (SQLException e) {
            System.out.println(e.getMessage());
        }
        return false;
    }

    /**
     * @return The full table of users
     * @throws SQLException
     */
    public ResultSet displayAllUsers() throws SQLException {
        try {
            statement = connection.createStatement();
            resultSet = statement.executeQuery(
                    "SELECT u.ID, u.Name, u.Email, u.PhoneNumber, u.Address, u.Password, e.Position, e.Salary, e.PostalCode, m.Balance, m.CREDITCARDNUMBER " +
                    "FROM Users u " +
                    "FULL OUTER JOIN Employee_WorksAt e " +
                    "ON u.ID = e.ID " +
                    "FULL OUTER JOIN Member m " +
                    "ON u.ID = m.ID ");
            return resultSet;
        }
        catch (SQLException e) {
            System.out.println(e.getMessage());
        }
        return null;
    }

    /**
     * Returns the given copy of the item
     * @param itemID
     * @param copyNumber
     * @param postalCode the branch the item is getting returned to
     * @return true if item is returned successfully
     * @throws SQLException
     */
    public boolean returnItem(String itemID, int copyNumber, String postalCode) throws SQLException {
        try {
            statement = connection.createStatement();
            statement.executeUpdate("UPDATE Status SET available = 1, SET DueDate = null, SET PostalCode = " + postalCode +
                    "WHERE itemID = " + itemID + " AND copyNumber = " + copyNumber);
            return true;
        }
        catch (SQLException e) {
            System.out.println(e.getMessage());
        }
        return false;
    }
}
