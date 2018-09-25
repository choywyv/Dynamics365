<%@ page import = "java.io.*, java.net.*, java.util.concurrent.*, com.microsoft.aad.adal4j.*, net.minidev.json.*" %>

<%!

// https://github.com/jlattimer/CrmWebApiJava/blob/master/src/main/java/com/JasonLattimer/CrmWebApiJava/CrmApplication.java

  String authority = "https://login.microsoftonline.com/common/oauth2/token", resource = URLtoDynamics;

/*  

  // for native
  String getAccessTokenPassword () throws MalformedURLException, IOException {

    return "resource=" + URLEncoder.encode(resource, java.nio.charset.StandardCharsets.UTF_8.toString())
           + "&client_id=" + URLEncoder.encode(CLIENT_ID_OR_APPLICATION_ID, java.nio.charset.StandardCharsets.UTF_8.toString())
           + "&grant_type=password&username=" + URLEncoder.encode(EMAIL, java.nio.charset.StandardCharsets.UTF_8.toString())
           + "&password=" + URLEncoder.encode(PASSWORD, java.nio.charset.StandardCharsets.UTF_8.toString())
           + "&scope=openid";

  }


  // for web app
  String getAccessTokenSecret () throws MalformedURLException, IOException {

    return "resource=" + URLEncoder.encode(resource, java.nio.charset.StandardCharsets.UTF_8.toString())
           + "&client_id=" + URLEncoder.encode(CLIENT_ID_OR_APPLICATION_ID, java.nio.charset.StandardCharsets.UTF_8.toString())
           + "&client_secret=" + URLEncoder.encode(SECRET, java.nio.charset.StandardCharsets.UTF_8.toString())
           + "&grant_type=client_credentials";

  }  

 
  String connect (String parameters) throws Exception {

      HttpURLConnection connection;

      connection = (HttpURLConnection) new URL(authority).openConnection();

      connection.setRequestMethod("POST");
      connection.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");
      connection.setRequestProperty("Content-Length", "" + Integer.toString(parameters.getBytes().length));
      connection.setDoOutput(true);
      connection.connect();
        
      BufferedWriter out = new BufferedWriter(new OutputStreamWriter(connection.getOutputStream()));
      out.write(parameters);
      out.close();
	    
      return getResponse (connection, "");

  }
*/

  String getResponse (HttpURLConnection connection, String valueToExtract) throws Exception {

    BufferedReader br;
    String s;
    StringBuffer res = new StringBuffer();

    br = new BufferedReader(new InputStreamReader(connection.getInputStream()));       
    for (; (s = br.readLine()) != null; ) res.append(s);
    br.close();

    return valueToExtract.equals ("") ? res.toString () : getJSONData (res.toString (), valueToExtract);

  }


  String getJSONData (String s, String valueToExtract) throws Exception {

    return ((JSONObject) JSONValue.parse(s)).get(valueToExtract).toString();

  }


  AuthenticationResult getAccessTokenFromUserCredentials() throws Exception {
    AuthenticationResult result = null;
    ExecutorService service = null;

    service = Executors.newFixedThreadPool(1);
    result = new AuthenticationContext("https://login.microsoftonline.com/common/oauth2", false, service).acquireToken(URLtoDynamics, APPLICATION, EMAIL, PASSWORD, null).get();
    service.shutdown();

    return result;

  }


  String getWhoAmI (String token) throws Exception {

    HttpURLConnection connection;
       
    connection = (HttpURLConnection) new URL("https://efmdev.crm5.dynamics.com/api/data/v9.0/WhoAmI").openConnection();
    connection.setRequestMethod("GET");
    connection.setRequestProperty("OData-MaxVersion", "4.0");
    connection.setRequestProperty("OData-Version", "4.0");
    connection.setRequestProperty("Accept", "application/json");
    connection.addRequestProperty("Authorization", "Bearer " + token);

    return getResponse (connection, "UserId");

  }

%>


<%

//  out.println(getAccessTokenPassword () + "<br>" + connect (getAccessTokenPassword ()));
//  out.println(getAccessTokenSecret () + "<br>" + connect (getAccessTokenSecret ()));
//  out.println(getAccessTokenPassword ());

%>

<br>


<%

    HttpURLConnection connection;
    AuthenticationResult result = getAccessTokenFromUserCredentials();

    out.println (getWhoAmI (result.getAccessToken ()));

%>

