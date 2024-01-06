<?php
$ip_server = $_SERVER['SERVER_ADDR'];

echo "<h1>Привет из контейнера в кластере куба</h1><br>";
echo "Айпишка контейнера - " .$ip_server. "<br><p>";
echo "<font color=green>А у вас как дела?</font>";

?>