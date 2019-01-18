

import javax.swing.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.io.IOException;
import java.io.OutputStream;
import java.io.PrintStream;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;


public class MainPage implements ActionListener {
    private JRadioButton memberRadioButton;
    private JRadioButton employeeRadioButton;
    private JTextField SearchByTextField;
    private JRadioButton titleRadioButton;
    private JRadioButton personRadioButton;
    private JButton searchByButton;
    private JButton checkAvailabilityOfTitleButton;
    private JButton sortItemsButton;
    private JTextField checkAvailabilityTextField;
    private JButton countItemsButton;
    private JTextField itemListSearchTextField;
    private JButton startItemListSearchButton;
    private JButton seeUserInfoButton;
    private JButton seeAllUserInfoButton;
    private JButton deleteItemButton;
    private JButton borrowItemByIDButton;
    private JButton returnItemByIDButton;
    private JButton avgRatingOfItemsButton;
    private JRadioButton minRadioButton;
    private JRadioButton maxRadioButton;
    private JTextField nameTextField;
    private JTextField emailTextField;
    private JTextField phoneNumberTextField;
    private JTextField addressTextField;
    private JButton updateUserInfoButton;
    private JButton viewMemberBalanceButton;
    private JButton updateCreditCardInfoButton;
    private JTextField updateCreditCardTextField;
    private JButton payBalanceButton;
    private JTextField payBalanceTextField;
    private JPanel MainPagePanel;
    private JTable table1;
    private JScrollPane resultsTableScroll;
    private JTextField borrowItemTextField;
    private JSpinner spinner3a;
    private JTextField deleteItemTextField;
    private JRadioButton deleteItemCompletely;
    private JSpinner deleteItemCopyNumberSpinner;
    private JTextArea outputTextArea;
    public JFrame mainFrame;
    public static Connection connection;
    private Item item;
    private Member member;
    private Employee employee;
    public int currentID;


    public static void main(String[] args) {
        MainPage mainPage = new MainPage();
    }

    public MainPage() {
        if (!connect()) {
            return;
        }
        System.out.println("MainPage Constructor");
        //This code loads up the UI. Please don't change it unless you're sure!
        mainFrame = new JFrame("MainPagePanel");
        mainFrame.setContentPane(MainPagePanel);
        mainFrame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        mainFrame.pack();
        mainFrame.setVisible(true);

        item = new Item();
        member = new Member(1);
        employee = new Employee(2);

        setUpButtons();
    }


    /**
     * This method is necessary for ActionListener to work
     */
    public void actionPerformed(ActionEvent e) {
        System.out.println("Default action event handler called. This is a problem!");
        //System.exit(0);
    }

    /**
     * Set up JButtons with ActionListeners and call to sql query
     * @param
     *
     */
    public void setUpButtons() {
        System.out.println("Init Buttons");

        //Setup sout to print to a text area
        PrintStream printStream = new PrintStream(new CustomOutputStream(outputTextArea));
        System.setOut(printStream);
        System.setErr(printStream);

        //Group Radio Buttons
        ButtonGroup bg1 = new ButtonGroup();
        bg1.add(memberRadioButton);
        bg1.add(employeeRadioButton);

        ButtonGroup bg2 = new ButtonGroup();
        bg2.add(titleRadioButton);
        bg2.add(personRadioButton);

        ButtonGroup bg3 = new ButtonGroup();
        bg3.add(minRadioButton);
        bg3.add(maxRadioButton);


        //Add listener to memberRadioButton
        memberRadioButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                System.out.println("memberRadioButton selected");
                boolean ready = getCurrentID();
                if (!ready) {
                    System.out.println("Current ID is -1. The query for member id went wrong");
                }
                else {
                    member.setMemberID(currentID);
                    System.out.println("Set member ID to" + currentID);
                }
            }
        });

        //Add listener to memberRadioButton
        employeeRadioButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                System.out.println("employeeRadioButton selected");
                boolean ready = getCurrentID();
                if (!ready) {
                    System.out.println("Current ID is -1. The query for employee id went wrong");
                }
                else {
                    employee.setEmployeeID(currentID);
                    System.out.println("Set Employee ID to " + currentID);
                }
            }
        });

        //Add listener to searchByButton
        searchByButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                System.out.println("searchByButton pressed");
                // retrieve input from the textbox
                String input = SearchByTextField.getText();
                //initiate query

                if (input != null) {
                    if (input.equals("")) {
                        System.out.println("Cannot query with empty string");
                        return;
                    }
                    if (titleRadioButton.isSelected()) {
                        System.out.println(input + " Title search");

                        try {
                            ResultSet resultSet = item.retrieveUsingTitle(input);
                            if (resultSet == null) {
                                System.out.println("Query searchByTitle returned no results. ResultSet is null");
                                return;
                            }

                            // get metadata on ResultSet
                            ResultSetMetaData resultSetMetaData = resultSet.getMetaData();

                            // get number of columns
                            int numCols = resultSetMetaData.getColumnCount();

                            // add column names to array
                            String [] column = getColumnNames(resultSetMetaData);
                            //store data in array. Array has 1000 rows
                            String [][] data = getResultData(resultSet, column);
                            //load table to UI
                            loadDisplayTable(data, column);

                        } catch (SQLException ex) {
                            System.out.println("Message: " + ex.getMessage());
                        }
                    } else if (personRadioButton.isSelected()) {
                        System.out.println(input + "Search by creator:");

                        try {
                            ResultSet resultSet = item.retrieveUsingPerson(input);
                            if (resultSet == null) {
                                System.out.println("Query searchByPerson returned no results. ResultSet is null");
                                return;
                            }

                            // get metadata on ResultSet
                            ResultSetMetaData resultSetMetaData = resultSet.getMetaData();

                            // get number of columns
                            int numCols = resultSetMetaData.getColumnCount();

                            // add column names to array
                            String [] column = getColumnNames(resultSetMetaData);
                            //store data in array. Array has 1000 rows
                            String [][] data = getResultData(resultSet,column);
                            //load table to UI
                            loadDisplayTable(data, column);

                        } catch (SQLException ex) {
                            System.out.println("Message: " + ex.getMessage());
                        }
                    }
                }
            }
        });


        //Add listener to checkAvailabilityOfTitleButton
        checkAvailabilityOfTitleButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                System.out.println("checkAvailabilityButtonPressed");

                // retrieve input from the textbox
                String input = checkAvailabilityTextField.getText();

                //initiate query
                if (input != null) {
                    if (input.equals("")) {
                        System.out.println("Cannot query with empty string");
                        return;
                    }
                    System.out.println(input + " Availability search");
                    try {
                        ResultSet resultSet = item.itemAvailable(input);
                        if (resultSet == null) {
                            System.out.println("Query checkItemAvailability returned no results. ResultSet is null");
                            return;
                        }

                        // get metadata on ResultSet
                        ResultSetMetaData resultSetMetaData = resultSet.getMetaData();

                        // get number of columns
                        int numCols = resultSetMetaData.getColumnCount();

                        // add column names to array
                        String [] column = getColumnNames(resultSetMetaData);
                        //store data in array. Array has 1000 rows
                        String [][] data = getResultData(resultSet,column);
                        //load table to UI
                        loadDisplayTable(data, column);

                    } catch (SQLException ex) {
                        System.out.println("Message: " + ex.getMessage());
                    }
                }
            }
        });

        //Add listener to sortItemsButton
        sortItemsButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                System.out.println("sortItemsButton pressed");
                try {
                    ResultSet resultSet = item.sortItems();
                    if (resultSet == null) {
                        System.out.println("Query sortItems returned no results. ResultSet is null");
                        return;
                    }

                    // get metadata on ResultSet
                    ResultSetMetaData resultSetMetaData = resultSet.getMetaData();

                    // get number of columns
                    int numCols = resultSetMetaData.getColumnCount();

                    // add column names to array
                    String [] column = getColumnNames(resultSetMetaData);
                    //store data in array. Array has 1000 rows
                    String [][] data = getResultData(resultSet,column);
                    //load table to UI
                    loadDisplayTable(data, column);

                } catch (SQLException ex) {
                    System.out.println("Message: " + ex.getMessage());
                }
            }
        });

        //Add listener to countItemsButton
        countItemsButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                System.out.println("countItemsButton pressed");
                try {
                    ResultSet resultSet = item.countItems();
                    if (resultSet == null) {
                        System.out.println("Query countItems returned no results. ResultSet is null");
                        return;
                    }

                    // get metadata on ResultSet
                    ResultSetMetaData resultSetMetaData = resultSet.getMetaData();

                    // get number of columns
                    int numCols = resultSetMetaData.getColumnCount();

                    // add column names to array
                    String [] column = getColumnNames(resultSetMetaData);
                    //store data in array. Array has 1000 rows
                    String [][] data = getResultData(resultSet,column);
                    //load table to UI
                    loadDisplayTable(data, column);

                } catch (SQLException ex) {
                    System.out.println("Message: " + ex.getMessage());
                }
            }
        });

        //Add listener to seeUserInfoButton
        seeUserInfoButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                System.out.println("seeUserInfoButton pressed");
                //initiate query
                try {
                    ResultSet resultSet;
                    if (employeeRadioButton.isSelected()) {
                        resultSet=employee.seeUserInfo();
                    } else {
                        resultSet = member.seeUserInfo();
                    }
                    if (resultSet == null) {
                        System.out.println("Query see User Info returned no results. ResultSet is null");
                        return;
                    }

                    // get metadata on ResultSet
                    ResultSetMetaData resultSetMetaData = resultSet.getMetaData();

                    // get number of columns
                    int numCols = resultSetMetaData.getColumnCount();

                    // add column names to array
                    String [] column = getColumnNames(resultSetMetaData);
                    //store data in array. Array has 1000 rows
                    String [][] data = getResultData(resultSet,column);
                    //load table to UI
                    loadDisplayTable(data, column);
                } catch (SQLException ex) {
                    System.out.println("Message: " + ex.getMessage());
                }

            }
        });

        //Add listener to seeAllUserInfoButton
        seeAllUserInfoButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                System.out.println("seeAllUserInfoButton pressed");
                if (employeeRadioButton.isSelected()) {
                    //initiate query
                    try {
                        ResultSet resultSet = employee.displayAllUsers();
                        if (resultSet == null) {
                            System.out.println("Query see AllUserInfo returned no results. ResultSet is null");
                            return;
                        }

                        // get metadata on ResultSet
                        ResultSetMetaData resultSetMetaData = resultSet.getMetaData();

                        // get number of columns
                        int numCols = resultSetMetaData.getColumnCount();

                        // add column names to array
                        String [] column = getColumnNames(resultSetMetaData);
                        //store data in array. Array has 1000 rows
                        String [][] data = getResultData(resultSet,column);
                        //load table to UI
                        loadDisplayTable(data, column);

                    } catch (SQLException ex) {
                        System.out.println("Message: " + ex.getMessage());
                    }
                } else {
                    System.out.println("You need to be an Employee to access this data");
                }
            }
        });

        //Add listener to startItemListSearchButton
        startItemListSearchButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                System.out.println("startItemListSearchButton pressed");
                // retrieve input from the textbox
                String input = itemListSearchTextField.getText();

                //initiate query
                if ((input != null)) {
                    if (input.equals("")) {
                        System.out.println("Cannot query with empty string");
                        return;
                    }
                    System.out.println(input + " Search for Items in list");
                    List<String> list = new ArrayList<>();
                    String[] arrSplit = input.split(",");
                    for (int i=0; i < arrSplit.length; i++)
                    {
                        list.add(arrSplit[i]);
                    }
                    try {
                        ResultSet resultSet = item.branchQuery(list, list.size());
                        if (resultSet == null) {
                            System.out.println("Query branchWithAllItems returned no results. ResultSet is null");
                            return;
                        }

                        // get metadata on ResultSet
                        ResultSetMetaData resultSetMetaData = resultSet.getMetaData();

                        // get number of columns
                        int numCols = resultSetMetaData.getColumnCount();

                        // add column names to array
                        String [] column = getColumnNames(resultSetMetaData);
                        //store data in array. Array has 1000 rows
                        String [][] data = getResultData(resultSet,column);
                        //load table to UI
                        loadDisplayTable(data, column);

                    } catch (SQLException ex) {
                        System.out.println("Message: " + ex.getMessage());
                    }
                }
            }
        });

        //Add listener to borrowItemByIDButton
        borrowItemByIDButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                System.out.println("borrowItemByIDButton pressed");
                // retrieve input from the textbox
                String input = borrowItemTextField.getText();
                String count = spinner3a.getValue().toString();

                //initiate query
                if ((input != null) && (count != null)) {
                    if (input.equals("")) {
                        System.out.println("Cannot query with empty string");
                        return;
                    }
                    System.out.println(input + " " + count + "Borrow Items in list");
                    try {
                        ResultSet resultSet = null;
                        try {
                            resultSet = item.borrowItem(currentID, Integer.parseInt(input), Integer.parseInt(count));
                        }
                        catch (NumberFormatException e1) {
                            System.out.println("Invalid item input.");
                        }
                        if (resultSet == null) {
                            System.out.println("Query borrow returned no results. ResultSet is null");
                            return;
                        }

                        // get metadata on ResultSet
                        ResultSetMetaData resultSetMetaData = resultSet.getMetaData();

                        // get number of columns
                        int numCols = resultSetMetaData.getColumnCount();

                        // add column names to array
                        String [] column = getColumnNames(resultSetMetaData);
                        //store data in array. Array has 1000 rows
                        String [][] data = getResultData(resultSet,column);
                        //load table to UI
                        loadDisplayTable(data, column);

                    } catch (SQLException ex) {
                        System.out.println("Message: " + ex.getMessage());
                    }
                }
            }
        });

        //Add listener to returnItemByIDButton
        returnItemByIDButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                System.out.println("returnItemByIDButton pressed");
                // retrieve input from the textbox
                int itemID = Integer.parseInt(borrowItemTextField.getText());
                int copyNum = Integer.parseInt(spinner3a.getValue().toString());

                //initiate query
                if ((itemID > 0) && (copyNum > 0)) {
                    System.out.println(itemID + " " + copyNum + "Return Items in list");
                    try {
                        ResultSet resultSet = item.returnItem(currentID, itemID, copyNum);
                        if (resultSet == null) {
                            System.out.println("Given item failed to return.");
                            return;
                        }
                        // get metadata on ResultSet
                        ResultSetMetaData resultSetMetaData = resultSet.getMetaData();

                        // get number of columns
                        int numCols = resultSetMetaData.getColumnCount();

                        // add column names to array
                        String[] column = getColumnNames(resultSetMetaData);
                        //store data in array. Array has 1000 rows
                        String[][] data = getResultData(resultSet, column);
                        //load table to UI
                        loadDisplayTable(data, column);
                    } catch (SQLException ex) {
                        System.out.println("Message: " + ex.getMessage());
                    }
                } else {
                    System.out.println("Cannot query with given item ID and copy number");
                }
            }
        });


        //Add listener to avgRatingOfItemsButton
        avgRatingOfItemsButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                System.out.println("avgRatingOfItemsButton pressed");
                if (maxRadioButton.isSelected()) {
                    System.out.println("Start max query");
                    try {
                        ResultSet resultSet = item.maxQuery();
                        if (resultSet == null) {
                            System.out.println("Query max returned no results. ResultSet is null");
                            return;
                        }

                        // get metadata on ResultSet
                        ResultSetMetaData resultSetMetaData = resultSet.getMetaData();

                        // get number of columns
                        int numCols = resultSetMetaData.getColumnCount();

                        // add column names to array
                        String [] column = getColumnNames(resultSetMetaData);
                        //store data in array. Array has 1000 rows
                        String [][] data = getResultData(resultSet,column);
                        //load table to UI
                        loadDisplayTable(data, column);

                    } catch (SQLException ex) {
                        System.out.println("Message: " + ex.getMessage());
                    }
                } else if (minRadioButton.isSelected()) {
                    System.out.println("Start in query");
                    try {
                        ResultSet resultSet = item.minQuery();
                        if (resultSet == null) {
                            System.out.println("Query min returned no results. ResultSet is null");
                            return;
                        }

                        // get metadata on ResultSet
                        ResultSetMetaData resultSetMetaData = resultSet.getMetaData();

                        // get number of columns
                        int numCols = resultSetMetaData.getColumnCount();

                        // add column names to array
                        String [] column = getColumnNames(resultSetMetaData);
                        //store data in array. Array has 1000 rows
                        String [][] data = getResultData(resultSet,column);
                        //load table to UI
                        loadDisplayTable(data, column);

                    } catch (SQLException ex) {
                        System.out.println("Message: " + ex.getMessage());
                    }
                } else {
                    System.out.println("Select max or min to make this query");
                }
            }
        });

        //Add listener to updateUserInfoButton
        updateUserInfoButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                System.out.println("updateUserInfoButton pressed");
                // retrieve info from text boxes
                String name = nameTextField.getText();
                String email = emailTextField.getText();
                String phoneNumber = phoneNumberTextField.getText();
                String address = addressTextField.getText();

                if ((name != null) && (email != null) && (phoneNumber != null) && (address != null)) {
                    if (name.equals("") || (email.equals("") || (phoneNumber.equals("") || (address.equals(""))))) {
                        System.out.println("Cannot query with empty string");
                        return;
                    }
                    System.out.println("Start update user info query");
                    if (memberRadioButton.isSelected()) {
                        try {
                            ResultSet resultSet = member.updateUserInfo(name, email, phoneNumber, address);
                            String[] columns = getColumnNames(resultSet.getMetaData());
                            String[][] data = getResultData(resultSet,columns);
                            loadDisplayTable(data, columns);
                        } catch (SQLException e1) {
                            e1.getMessage();
                        }
                    }
                    else if (employeeRadioButton.isSelected()) {
                        try {
                            ResultSet resultSet = employee.updateUserInfo(name, email, phoneNumber, address);
                            String[] columns = getColumnNames(resultSet.getMetaData());
                            String[][] data = getResultData(resultSet,columns);
                            loadDisplayTable(data, columns);
                        } catch (SQLException e1) {
                            e1.getMessage();
                        }
                    }
                }
            }
        });

        //Add listener to viewMemberBalanceButton
        viewMemberBalanceButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                System.out.println("viewMemberBalanceButton pressed");
                try {
                    double balance = member.viewMemberBalance();
                    System.out.println("Member balance is " + balance);
                } catch (SQLException e1) {
                    e1.getMessage();
                }
            }
        });

        //Add listener to updateCreditCardInfoButton
        updateCreditCardInfoButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                System.out.println("updateCreditCardInfoButton pressed");
                // retrieve info from text boxes
                String creditCardNum = updateCreditCardTextField.getText();
                if (creditCardNum == null) return;
                try {
                    Long.parseLong(creditCardNum, 10);
                }
                catch (NumberFormatException e1) {
                    System.out.println("Invalid credit card input.");
                    return;
                }

                if (memberRadioButton.isSelected()) {
                    if (creditCardNum.equals("")) {
                        System.out.println("Cannot query with empty string");
                        return;
                    }
                    System.out.println("Start update credit card num update query");
                    try {
                        ResultSet resultSet = member.updateCreditCard(creditCardNum);
                        String[] columns = getColumnNames(resultSet.getMetaData());
                        String[][] data = getResultData(resultSet,columns);
                        loadDisplayTable(data, columns);
                        System.out.println("Credit card updated to " + creditCardNum);
                    } catch (SQLException e1) {
                        e1.getMessage();
                    }
                } else if (employeeRadioButton.isSelected()){
                    System.out.println("Only members may update credit card info");
                }
                //loadDisplayTable(data, column);
            }
        });

        //Add listener to payBalanceButton
        payBalanceButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                System.out.println("payBalanceButton pressed");
                // retrieve info from text boxes
                String balanceToPay = payBalanceTextField.getText();

                if ((balanceToPay != null) && memberRadioButton.isSelected()) {
                    if (balanceToPay.equals("")) {
                        System.out.println("Cannot query with empty string");
                        return;
                    }
                    System.out.println("Start pay balance query");
                    try {
                        double newBalance = member.payMemberBalance(balanceToPay);
                        System.out.println("Payment successful. New balance is " + newBalance);
                    } catch (SQLException e1) {
                        e1.printStackTrace();
                    }
                } else if (employeeRadioButton.isSelected()){
                    System.out.println("Only members may pay a balance");
                }
            }
        });

        //Add listener to deleteItemButton
        deleteItemButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                //delete item from database entirely
                if (memberRadioButton.isSelected()) {
                    System.out.println("Only employees may delete items from database");
                    return;
                }
                // retrieve info from text boxes
                String itemIDtoDelete = deleteItemTextField.getText();
                int copyNumber = (Integer) deleteItemCopyNumberSpinner.getValue();

                if (itemIDtoDelete == null || itemIDtoDelete.equals("")) {
                    System.out.println("Cannot query with empty itemID");
                    return;
                }

                if (deleteItemCompletely.isSelected()) {
                    System.out.println("Deleting item from database entirely");
                    try {
                        if (employee.deleteItemCompletely(itemIDtoDelete)) {
                            System.out.println("Deleted " + itemIDtoDelete + " from database");
                        }
                        else {
                            System.out.println("Deletion of " + itemIDtoDelete + " failed. Check the itemID.");
                        }
                    }
                    catch (SQLException e1) {
                        System.out.println(e1.getMessage());
                    }
                }
                else { //delete single copy of item
                    System.out.println("Deleting copy of item: ");
                    try {
                        if (employee.deleteSingleCopyOfItem(itemIDtoDelete, copyNumber)) {
                            System.out.println("Deleted " + itemIDtoDelete + " number " + copyNumber);
                        }
                        else {
                            System.out.println("Deletion of " + itemIDtoDelete + " number " + copyNumber + " failed.");
                        }
                    }
                    catch (SQLException e1) {
                        System.out.println(e1.getMessage());
                        System.out.println("Deletion of " + itemIDtoDelete + " number " + copyNumber + " failed.");
                    }
                }

                //loadDisplayTable(data, column);
            }
        });


    }

    /**
     * Retrieve a member ID from the data base
     * @return int
     *
     */
    public boolean getCurrentID() {
        int result = -1;
        try {
            Statement statement = connection.createStatement();
            ResultSet resultSet;
            if (memberRadioButton.isSelected()){
                resultSet = statement.executeQuery("SELECT ID FROM MEMBER WHERE ROWNUM = 1");
            } else if (employeeRadioButton.isSelected()) {
                resultSet = statement.executeQuery("SELECT ID FROM Employee_WorksAT WHERE ROWNUM = 1");
            } else {
                System.out.println("One of Employee or Member needs to be selected");
                return false;
            }
            if (resultSet != null) {
                if (resultSet.next()) {
                    result = resultSet.getInt("ID");
                }
            }
            statement.close();
        } catch (SQLException ex) {
            System.out.println("Message: " + ex.getMessage());
        }
        if (result == -1) {
            return false;
        } else {
            currentID = result;
        }
        return true;
    }

    /**
     * Load String data and column names into a table. Present table in GUI
     * @param data, column
     *
     */
    public void loadDisplayTable(String [][] data, String [] column) {
        MainPagePanel.remove(resultsTableScroll);
        table1 = new JTable(data,column);
        resultsTableScroll.getViewport().add(table1);
        MainPagePanel.add(resultsTableScroll);
    }

    private String [][] getResultData(ResultSet resultSet, String [] column) throws SQLException {
        if (resultSet == null) return null;
        if (column == null) return null;
        int numColumns = column.length;
        if (numColumns < 1) return null;

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

    /**
     * Connect to oracle database
     */
    private boolean connect() {
        String connectURL = "jdbc:oracle:thin:@dbhost.ugrad.cs.ubc.ca:1522:ug";

        try {
            // Load the Oracle JDBC driver
            DriverManager.registerDriver(new oracle.jdbc.driver.OracleDriver());
        } catch (SQLException ex) {
            System.out.println("Message: " + ex.getMessage());
            System.exit(-1);
        }

        try {
            String username = "ora_t4a1b";
            String password = "a26689159";
            connection = DriverManager.getConnection(connectURL,username,password);

            System.out.println("\nConnected to Oracle!");
            return true;
        } catch (SQLException ex) {
            System.out.println("Message: " + ex.getMessage());
            return false;
        }
    }

    /**
     * This class extends from OutputStream to redirect output to a JTextArea
     * @author www.codejava.net
     *
     *
     */
    public class CustomOutputStream extends OutputStream {
        private JTextArea textArea;

        public CustomOutputStream(JTextArea textArea) {
            this.textArea = textArea;
        }

        @Override
        public void write(int b) throws IOException {
            // redirects data to the text area
            textArea.append(String.valueOf((char)b));
            // scrolls the text area to the end of data
            textArea.setCaretPosition(textArea.getDocument().getLength());
        }
    }
}
