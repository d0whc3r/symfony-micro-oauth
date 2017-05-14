<?php

namespace AppBundle\Controller;

use FOS\RestBundle\Controller\Annotations as Rest;
use FOS\RestBundle\Request\ParamFetcher;
use Nelmio\ApiDocBundle\Annotation\ApiDoc;

/**
 * @Rest\View
 * @Rest\NamePrefix("restpost_")
 */
class PostRestController extends HelperController
{
    /**
     * @ApiDoc(description="Execute remote action once identified and authorized")
     *
     * @Rest\RequestParam(name="action", nullable=false, description="Rest api action")
     * @Rest\RequestParam(name="method", nullable=true, default="GET", requirements="[GET|POST|PUT|DELETE]", description="Method")
     * @Rest\RequestParam(name="data", nullable=true, description="Data to send")
     *
     * @param ParamFetcher $paramFetcher
     *
     * @return array
     */
    public function actAction(ParamFetcher $paramFetcher)
    {
        $action = $paramFetcher->get('action');
        $method = $paramFetcher->get('method');
        $data = $paramFetcher->get('data');
        if(!$data) {
            $data = [];
        }

        return $this->curl($action, $method, $data);
    }

}
