<?php

namespace AppBundle\Security;

use HWI\Bundle\OAuthBundle\OAuth\Response\PathUserResponse;

class CustomUserResponse extends PathUserResponse
{

    public function getLastLogin()
    {
        $date = $this->getValueForPath('last_login');
//    $str = strtotime($date);
//    return date('Y-m-d H:i:s', $str);
        return new \DateTime($date);
    }

    public function getRoles()
    {
        return $this->getValueForPath('roles');
    }

    public function getEnabled()
    {
        return $this->getValueForPath('enabled');
    }

    public function getLocked()
    {
        return $this->getValueForPath('locked');
    }

    public function getExpired()
    {
        return $this->getValueForPath('expired');
    }

}
