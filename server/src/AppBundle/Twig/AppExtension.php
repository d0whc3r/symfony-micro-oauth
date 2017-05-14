<?php

namespace AppBundle\Twig;

class AppExtension extends \Twig_Extension
{

    public function getFilters()
    {
        return [
            new \Twig_SimpleFilter('md5', [$this, 'setMd5']),
            new \Twig_SimpleFilter('encode64', [$this, 'setEBase64']),
            new \Twig_SimpleFilter('decode64', [$this, 'setDBase64']),
            new \Twig_SimpleFilter('dump', [$this, 'showDump']),
            new \Twig_SimpleFilter('random', [$this, 'showRandom']),
        ];
    }

    public function showRandom($max)
    {
        $characters = 'abcdefghijklmnopqrstuvwxyz0123456789';
        $string = '';
        for ($i = 0; $i < $max; $i++) {
            $string .= $characters[rand(0, strlen($characters) - 1)];
        }
        return $string;
    }

    public function showDump($value)
    {
        dump($value);
        return "DUMPED!";
    }

    public function setMd5($value)
    {
        return md5($value);
    }

    public function setEBase64($value)
    {
        return base64_encode($value);
    }

    public function setDBase64($value)
    {
        return base64_decode($value);
    }

    public function getName()
    {
        return 'app_extension';
    }

}
