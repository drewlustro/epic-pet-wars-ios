<?
function lcfirst($str) {
  if (strlen($str) > 0) {
    $str[0] = strtolower($str[0]);
  }
  return $str;
}

if (count($argv) < 2) {
  echo "Please provide an input file\n";
  exit;
}

$file = fopen($argv[1], 'r');
if (!$file) {
  echo "Invalid input file\n";
  exit;
}

$object_name = trim(fgets($file));
$num_per_load = trim(fgets($file));
$rest_call = trim(fgets($file));


$fields = array();
$camel_cased_fields = array();
while (!feof($file)) {
  $buffer = fgets($file);
  $field = trim($buffer);
  if ($field) {
    $fields[] = $field;
    $seperated_field = explode('_', $field);
    $camel_case = $seperated_field[0];
    for ($i = 1; $i < count($seperated_field); $i += 1) {
      $camel_case .= ucwords($seperated_field[$i]);
    }
    $camel_cased_fields[] = $camel_case;
  }
}

if (count($camel_cased_fields) == 0) {
  return;
}

$date = strftime("%D");

ob_start();
include("object.h.php");
$object_h_file = ob_get_clean();

$file = fopen("$object_name.h", 'w+');
fwrite($file, $object_h_file);
fclose($file);

ob_start();
include("object.m.php");
$object_m_file = ob_get_clean();

$file = fopen("$object_name.m", 'w+');
fwrite($file, $object_m_file);
fclose($file);

ob_start();
include("object_collection.h.php");
$object_collection_h_file = ob_get_clean();

$file = fopen("{$object_name}RemoteCollection.h", 'w+');
fwrite($file, $object_collection_h_file);
fclose($file);

ob_start();
include("object_collection.m.php");
$object_collection_m_file = ob_get_clean();

$file = fopen("{$object_name}RemoteCollection.m", 'w+');
fwrite($file, $object_collection_m_file);
fclose($file);
