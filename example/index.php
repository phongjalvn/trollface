<?php
//Set http header
header('content-type: application/json; charset=utf-8');

//Set header for cors request
header("access-control-allow-origin: *");

//Check valid jsonp callback
function is_valid_callback($subject)
{
    $identifier_syntax
      = '/^[$_\p{L}][$_\p{L}\p{Mn}\p{Mc}\p{Nd}\p{Pc}\x{200C}\x{200D}]*+$/u';

    $reserved_words = array('break', 'do', 'instanceof', 'typeof', 'case',
      'else', 'new', 'var', 'catch', 'finally', 'return', 'void', 'continue', 
      'for', 'switch', 'while', 'debugger', 'function', 'this', 'with', 
      'default', 'if', 'throw', 'delete', 'in', 'try', 'class', 'enum', 
      'extends', 'super', 'const', 'export', 'import', 'implements', 'let', 
      'private', 'public', 'yield', 'interface', 'package', 'protected', 
      'static', 'null', 'true', 'false');

    return preg_match($identifier_syntax, $subject)
        && ! in_array(mb_strtolower($subject, 'UTF-8'), $reserved_words);
}

$query_folder = $_GET['dir'];

if (!$query_folder):
  $query_folder = 'data';
endif;

$data = glob($query_folder.'/*.{jpg,gif,png,jpeg}', GLOB_BRACE);

//Json encode, your mother fackar
$json = json_encode($data);

# JSON if no callback
if( ! isset($_GET['callback']))
    exit($json);

# JSONP if valid callback
if(is_valid_callback($_GET['callback']))
    exit("{$_GET['callback']}($json)");

# Otherwise, bad request
header('status: 400 Bad Request', true, 400);
