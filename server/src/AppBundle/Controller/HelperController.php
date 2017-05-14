<?php

namespace AppBundle\Controller;

use FOS\RestBundle\Controller\Annotations as Rest;
use FOS\RestBundle\Controller\FOSRestController;

/**
 * @Rest\View
 * @Rest\NamePrefix("rest_")
 */
class HelperController extends FOSRestController
{

    private $BASE_URL = false;

    function __construct()
    {
//        $this->BASE_URL = 'http://' . getenv('DOCKER_SERVICES');
    }

    protected function curl($action, $method, $data)
    {
        $curl = curl_init();

        $url = $action;
        if ($this->BASE_URL) {
            $url = $this->BASE_URL . $action;
        }

        curl_setopt_array($curl, array(
            CURLOPT_URL => $url,
            CURLOPT_RETURNTRANSFER => true,
            CURLOPT_ENCODING => "UTF-8",
            CURLOPT_MAXREDIRS => 10,
            CURLOPT_TIMEOUT => 30,
            CURLOPT_HTTP_VERSION => CURL_HTTP_VERSION_1_1,
            CURLOPT_CUSTOMREQUEST => $method,
            CURLOPT_POSTFIELDS => json_encode($data),
            CURLOPT_HTTPHEADER => array(
                "accept: application/json",
                "cache-control: no-cache",
                "content-type: application/json",
            ),
        ));

        $response = curl_exec($curl);
        $err = curl_error($curl);

        if ($err) {
            $response = ['errror' => curl_getinfo($curl, CURLINFO_HTTP_CODE), 'msg' => $err];
        } else {
            $response = json_decode($response, true);
        }

        curl_close($curl);

        return $response;
    }

}
