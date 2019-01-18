import java.sql.*;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

public class Item {
    Statement statement;
    ResultSet resultSet;
    Connection connection;

    public Item() {
        connection = MainPage.connection;
    }

    /**
     * Given a item title finds the items attributes
     * @param title
     * @return returns items with corresponding title
     *
     */

    public ResultSet retrieveUsingTitle(String title) throws SQLException {
        try {
            statement = connection.createStatement();
            resultSet = statement.executeQuery("SELECT  i.ItemID, i.Title, i.CopyNumber, i.genre, i.UserScore, i.LendingPeriod, i.Available, i.DueDate, i.PostalCode " +
                    "FROM Item_HeldAt_Borrows i " +
                    "WHERE i.title LIKE '%" + title + "%'");
            return resultSet;
        }
        catch (SQLException e) {
            System.out.println(e.getMessage());
        }
        return null;
    }

    /**
     * Given a item title finds the items attributes
     * @param person
     * @return returns items with corresponding person as Author/Narrator/Director
     *
     */


    public ResultSet retrieveUsingPerson(String person) throws SQLException {
        try {
            statement = connection.createStatement();
            resultSet = statement.executeQuery("SELECT i.ItemID, i.CopyNumber, i.Genre, i.Title, i.UserScore, i.LendingPeriod, i.Available, i.PostalCode " +
                    "FROM Item_HeldAt_Borrows i " +
                    "FULL OUTER JOIN BookInfo b " +
                    "ON b.ItemID = i.ItemID " +
                    "WHERE b.FullName LIKE '%" + person + "%' " +
                    "UNION " +
                    "SELECT i.ItemID, i.CopyNumber, i.Genre, i.Title, i.UserScore, i.LendingPeriod, i.Available, i.PostalCode " +
                    "FROM Item_HeldAt_Borrows i " +
                    "FULL OUTER JOIN AudioBookInfo a " +
                    "ON a.ItemID = i.ItemID " +
                    "WHERE a.FullName LIKE '%" + person + "%' " +
                    "UNION " +
                    "SELECT i.ItemID, i.CopyNumber, i.Genre, i.Title, i.UserScore, i.LendingPeriod, i.Available, i.PostalCode " +
                    "FROM Item_HeldAt_Borrows i " +
                    "FULL OUTER JOIN MovieInfo m " +
                    "ON m.ItemID = i.ItemID " +
                    "WHERE m.FullName LIKE '%" + person + "%'");
            return resultSet;

        }
        catch (SQLException e) {
            System.out.println(e.getMessage());
        }
        return null;
    }

    /**
     * Find availability of the given item
     * @param title
     * @return returns items with corresponding title if availability is true
     *
     */

    public ResultSet itemAvailable(String title) {
        try {
            statement = connection.createStatement();
            resultSet = statement.executeQuery("SELECT i.ItemID, i.CopyNumber, i.Title, i.Available " +
                    "FROM Item_HeldAt_Borrows i WHERE i.Title LIKE '%" + title +
                    "%' AND i.Available = 1");
            return resultSet;
        }
        catch (SQLException e) {
            System.out.println(e.getMessage());
        }
        return null;
    }


    /**
     * Sorts items based on user rating
     *
     * @return returns items sorted according to UserScore
     *
     */

    public ResultSet sortItems() {
        try {
            statement = connection.createStatement();
            resultSet = statement.executeQuery("SELECT * FROM Item i ORDER BY i.UserScore, i.ItemID");
            return resultSet;
        }
        catch (SQLException e) {
            System.out.println(e.getMessage());
        }
        return null;
    }


    /**
     * Count the number of items
     *
     * @return returns number of items grouped by ID
     *
     */

    public ResultSet countItems() {
        try {
            statement = connection.createStatement();
            resultSet = statement.executeQuery("SELECT i.ItemID, i.Title, i.UserScore, count(i.ItemID) AS \"Count\"" +
                    "FROM Item_HeldAt_Borrows i " +
                    "GROUP BY i.ItemID, i.Title, i.UserScore " +
                    "ORDER BY count(i.ItemID) DESC");
            return resultSet;
        }
        catch (SQLException e) {
            System.out.println(e.getMessage());
        }
        return null;
    }

    /**
     * Borrow an item
     * @param memberID
     * @param itemID
     * @param copyNumber
     * @return returns item with updated Status
     *
     */

    public ResultSet borrowItem(int memberID, int itemID, int copyNumber) {
        try {
            statement = connection.createStatement();
            resultSet = statement.executeQuery("SELECT Available " +
                    "FROM  Item_HeldAt_Borrows i " +
                    "WHERE ItemID = " + itemID +
                    " AND CopyNumber = " + copyNumber);
            if(getAvailability(resultSet))
            {
                DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
                int noOfDays = 14; //two weeks
                Calendar calendar = Calendar.getInstance();
                calendar.setTime(calendar.getTime());
                calendar.add(Calendar.DAY_OF_YEAR, noOfDays);
                Date date = calendar.getTime();
                String varDueDate = dateFormat.format(date);
                System.out.println(varDueDate);
                statement.executeQuery("UPDATE Status SET Available = 0, DueDate = '" + varDueDate +
                        "', ID = " + memberID + " WHERE ItemID = " + itemID +
                        " AND CopyNumber = " + copyNumber);
                resultSet = statement.executeQuery("SELECT * " +
                        "FROM  Status " +
                        "WHERE ItemID = " + itemID +
                        " AND CopyNumber = " + copyNumber);
            }
            return resultSet;
        }
        catch (SQLException e) {
            System.out.println(e.getMessage());
            System.out.println("Item failed to be borrowed.");
        }
        return null;
    }

    /**
     * Return a borrowed item
     * @param memberID
     * @param itemID
     * @param copyNumber
     * @return returns item with updated Status
     *
     */

    public ResultSet returnItem(int memberID, int itemID, int copyNumber) {
        //update balance when being returned
        try {
            Date dateFromQ = new Date();
            int overdueCost = -10;
            statement = connection.createStatement();
            resultSet = statement.executeQuery("SELECT DueDate " +
                    "FROM  Status s " +
                    "WHERE s.ItemID = " + itemID +
                    " AND s.CopyNumber = " + copyNumber);
            String temp = getDueDate(resultSet);
            DateFormat format = new SimpleDateFormat("yyyy-MM-dd");
            try {
                dateFromQ = format.parse(temp);
            } catch (ParseException e) {
                e.printStackTrace();
            }
            Date currentDate = Calendar.getInstance().getTime();
            if (dateFromQ.after(dateFromQ)) {
                resultSet = statement.executeQuery("SELECT Balance FROM Member WHERE ID = " + memberID);
                float balance = getBalance(resultSet) + overdueCost;
                statement.executeQuery("UPDATE Member SET Balance = " + balance + " WHERE ID = " + memberID);
            }
        }
        catch (SQLException e1) {
            System.out.println(e1.getMessage());
        }

        try {
            System.out.println("Trying to return " + itemID + " with copyNumber " + copyNumber);
            statement = connection.createStatement();
            resultSet = statement.executeQuery("UPDATE Status SET Available = 1, DueDate = NULL, ID = NULL" +
                    " WHERE ItemID = " + itemID + " AND CopyNumber = " + copyNumber);
            resultSet = statement.executeQuery("SELECT * " +
                    "FROM  Status " +
                    "WHERE ItemID = " + itemID +
                    " AND CopyNumber = " + copyNumber);
            if (resultSet == null) System.out.println("RESULTSET IS NULL, WHY?");
            return resultSet;
        }
        catch (SQLException e) {
            System.out.println(e.getMessage());
        }
        return null;
    }

    /**
     * Min of Average Rating of Items per Branch
     *
     * @return returns item with updated Status
     *
     */

    public ResultSet minQuery() {
        try {
            statement = connection.createStatement();
            resultSet = statement.executeQuery("SELECT b.PostalCode, avg(i.UserScore) AS \"Average\"" +
                    " FROM Item_HeldAt_Borrows i, Branch b" +
                    " WHERE b.PostalCode = i.PostalCode" +
                    " GROUP BY b.PostalCode" +
                    " HAVING avg(i.UserScore) <= ALL" +
                    " (SELECT avg(tempI.UserScore)" +
                    " FROM Item_HeldAt_Borrows tempI, Branch tempB" +
                    " WHERE tempB.PostalCode = tempI.PostalCode" +
                    " GROUP BY tempB.PostalCode)");
            /*resultSet = statement.executeQuery("SELECT b.PostalCode, avg(i.UserScore) AS \"Average\"" +
                    " FROM Item_HeldAt_Borrows i, Branch b" +
                    " WHERE b.PostalCode = i.PostalCode" +
                    " GROUP BY b.PostalCode");*/
            return resultSet;
        }
        catch (SQLException e) {
            System.out.println(e.getMessage());
        }
        return null;
    }

    /**
     * Max of Average Rating of Items per Branch
     *
     * @return returns item with updated Status
     *
     */

    public ResultSet maxQuery() {
        try {
            statement = connection.createStatement();
            resultSet = statement.executeQuery("SELECT b.PostalCode, avg(i.UserScore) AS \"Average\"" +
                    " FROM Item_HeldAt_Borrows i, Branch b" +
                    " WHERE b.PostalCode = i.PostalCode" +
                    " GROUP BY b.PostalCode" +
                    " HAVING avg(i.UserScore) >= ALL" +
                    " (SELECT avg(tempI.UserScore)" +
                    " FROM Item_HeldAt_Borrows tempI, Branch tempB" +
                    " WHERE tempB.PostalCode = tempI.PostalCode" +
                    " GROUP BY tempB.PostalCode)");
            return resultSet;
        }
        catch (SQLException e) {
            System.out.println(e.getMessage());
        }
        return null;
    }


    /**
     * Given a list of item titles, find branches that are holding all of them
     * @param list
     * @return returns branch name and postal code
     *
     */

    public ResultSet branchQuery(List<String> list, int count) {
        try {
            String sqlQuery = "SELECT b.PostalCode, b.BranchName, b.Hours, b.Address FROM Branch b WHERE NOT EXISTS (SELECT i.PostalCode FROM Item_HeldAt_Borrows i WHERE NOT EXISTS (";

            for(int k = 0; k < count; k++)
            {
                sqlQuery = sqlQuery + "SELECT i.PostalCode FROM Item_HeldAt_Borrows i WHERE b.PostalCode = i.PostalCode AND " + "i.Title LIKE '%" + list.get(k) + "%'";
                if(k+1 < count)
                    sqlQuery = sqlQuery + " INTERSECT ";
            }
            sqlQuery = sqlQuery + "))";
            resultSet = statement.executeQuery(sqlQuery);
            return resultSet;
        }
        catch (SQLException e) {
            System.out.println(e.getMessage());
        }
        return null;
    }


    private boolean getAvailability(ResultSet resultSet)
    {
        try {
            if (resultSet == null) {
                System.out.println("Query returned no results. ResultSet is null");
                return false;
            }

            // get metadata on ResultSet
            ResultSetMetaData resultSetMetaData = resultSet.getMetaData();

            // get number of columns
            int numCols = resultSetMetaData.getColumnCount();

            // add column names to array
            String [] column = getColumnNames(resultSetMetaData);
            //store data in array. Array has 1000 rows
            String [][] data = getResultData(resultSet,numCols,column);
            //load table to UI
            return (Integer.parseInt(data[0][0]) == 1);

        } catch (SQLException ex) {
            System.out.println("Message: " + ex.getMessage());
            return false;
        }
    }

    private float getBalance(ResultSet resultSet)
    {
        try {
            if (resultSet == null) {
                System.out.println("Query returned no results. ResultSet is null");
                return 0;
            }

            // get metadata on ResultSet
            ResultSetMetaData resultSetMetaData = resultSet.getMetaData();

            // get number of columns
            int numCols = resultSetMetaData.getColumnCount();

            // add column names to array
            String [] column = getColumnNames(resultSetMetaData);
            //store data in array. Array has 1000 rows
            String [][] data = getResultData(resultSet,numCols,column);
            //load table to UI
            return Float.parseFloat(data[0][0]);

        } catch (SQLException ex) {
            System.out.println("Message: " + ex.getMessage());
            return 0;
        }
    }

    /**
     * Given a query result, get the DueDate
     * @param resultSet
     * @return returns DueDate as a String
     *
     */

    private String getDueDate(ResultSet resultSet)
    {
        try {
            if (resultSet == null) {
                System.out.println("Query returned no results. ResultSet is null");
                return null;
            }

            // get metadata on ResultSet
            ResultSetMetaData resultSetMetaData = resultSet.getMetaData();

            // get number of columns
            int numCols = resultSetMetaData.getColumnCount();

            // add column names to array
            String [] column = getColumnNames(resultSetMetaData);
            //store data in array. Array has 1000 rows
            String [][] data = getResultData(resultSet,numCols,column);
            //load table to UI
            return data[0][0];

        } catch (SQLException ex) {
            System.out.println("Message: " + ex.getMessage());
            return null;
        }
    }

    private String [][] getResultData(ResultSet resultSet, int numColumns, String [] column) throws SQLException {
        if (resultSet == null) return null;
        if (numColumns < 1) return null;
        if (column == null) return null;

        //store data in array. Array has 1000 rows
        String [][] data = new String[1000][numColumns];
        int rowIndex = 0;
        while(resultSet.next() && rowIndex < 1000) {
            String [] oneRow = new String[numColumns];
            for (int i = 0; i < numColumns; i++) {
                oneRow[i]= resultSet.getString(column[i]);
            }
            data[rowIndex] = oneRow;
            rowIndex++;
        }
        return data;
    }

    private String [] getColumnNames(ResultSetMetaData resultSetMetaData) throws SQLException {
        if (resultSetMetaData == null) return null;
        int numCols = resultSetMetaData.getColumnCount();
        if (numCols < 1) return null;
        String[] column = new String[numCols];
        try {
            for (int i = 0; i < numCols; i++) {
                column[i] = resultSetMetaData.getColumnName(i + 1);
            }
        } catch(SQLException e){
            System.out.println("Message: " + e.getMessage());
        }
        return column;
    }

}



