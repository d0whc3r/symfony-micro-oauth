<?php

namespace AppBundle\Model;

use FOS\UserBundle\Model\UserInterface as BaseInterface;

interface UserInterface extends BaseInterface
{

    /**
     * Sets the realname.
     *
     * @param string $realname
     *
     * @return self
     */
    public function setRealname($realname);

    /**
     * Gets the realname.
     *
     * @return string
     */
    public function getRealname();
}
