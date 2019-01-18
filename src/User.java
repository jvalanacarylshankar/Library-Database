import java.sql.*;

public interface User {

    /**
     * Selects the user info associated with current ID
     * todo connect to seeMemberInfoButton
     * @return Array
     * @throws SQLException
     */
    ResultSet seeUserInfo() throws SQLException;


    /**
     * Updates the user associated with given ID to match all given parameters, if they're not null
     * todo connect to updateUserInfoButton
     * @param name
     * @param email
     * @param phoneNumber
     * @param address
     * @throws SQLException
     */
    ResultSet updateUserInfo(String name, String email, String phoneNumber, String address) throws SQLException;

}
