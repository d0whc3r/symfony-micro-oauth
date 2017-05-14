<?php

namespace AppBundle\Controller\Admin;

use FOS\RestBundle\Controller\Annotations as Rest;
use FOS\RestBundle\Controller\FOSRestController;
use Nelmio\ApiDocBundle\Annotation\ApiDoc;

/**
 * @Rest\View
 * @Rest\NamePrefix("admin_rest_")
 */
class RestController extends FOSRestController
{
    /**
     * @ApiDoc(description="Get user info")
     *
     * @return \AppBundle\Entity\FosUser
     */
    public function userAction()
    {
        return $this->getUser();
    }


}
