<?php
$con=mysqli_connect("db56.grserver.gr:3306","antimeteo","2392lampiriS","FORECASTS");
if (!$con)
  {
  die('Could not connect: ' . mysqli_error($con));
  }
  
  $sql2="DELETE FROM search2;";
$result2 = mysqli_query($con,$sql2);
  
echo $result2;

  $sql="LOAD DATA LOCAL INFILE 'weatherspot.txt' INTO TABLE search2 ";

$result = mysqli_query($con,$sql);

echo $result;

     $con->close();
?>