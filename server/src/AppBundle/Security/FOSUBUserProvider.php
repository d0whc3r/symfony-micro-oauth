<?php

namespace AppBundle\Security;

use HWI\Bundle\OAuthBundle\OAuth\Response\UserResponseInterface;
use HWI\Bundle\OAuthBundle\Security\Core\User\FOSUBUserProvider as BaseClass;
use Symfony\Component\Security\Core\User\UserInterface;

//use HWI\Bundle\OAuthBundle\OAuth\Response\PathUserResponse;

class FOSUBUserProvider extends BaseClass
{
    /**
     * {@inheritdoc}
     */
    public function connect(UserInterface $user, UserResponseInterface $response)
    {
        $property = $this->getProperty($response);
        $username = $response->getUsername();
        //on connect - get the access token and the user ID
        $service = $response->getResourceOwner()->getName();
        $setter = 'set' . ucfirst($service);
        $setter_id = $setter . 'Id';
        $setter_token = $setter . 'AccessToken';
        //we "disconnect" previously connected users
        if (null !== $previousUser = $this->userManager->findUserBy([$property => $username])) {
            $previousUser->$setter_id(null);
            $previousUser->$setter_token(null);
            $this->userManager->updateUser($previousUser);
        }
        //we connect current user
        $user->$setter_id($username);
        $user->$setter_token($response->getAccessToken());
        $this->userManager->updateUser($user);
    }

    public function loadUserByOAuthUserResponse(UserResponseInterface $response)
    {
        $username = $response->getUsername();
        if (!$username) {
            return false;
        }
        $user = $this->userManager->findUserBy(['customId' => $username]);
        //when the user is registrating
        $service = $response->getResourceOwner()->getName();
        $setter = 'set' . ucfirst($service);
        $setter_id = $setter . 'Id';
        if (null === $user) {
            $user = $this->userManager->createUser();
            $user->$setter_id($username);
        }
        $setter_token = $setter . 'AccessToken';
        $user->$setter_token($response->getAccessToken());
        $user->setUsername($response->getUsername());
        $user->setNickname($response->getNickname());
        $user->setRealname($response->getRealName());
        $user->setEmail($response->getEmail());
        //$user->setPassword($use);
        $roles = $response->getRoles();
        if (!$roles) {
            $roles = [];
        }
        $user->setRoles($roles);
        $user->setLastLogin($response->getLastLogin());
        $user->setEnabled($response->getEnabled());
        $user->setExpired($response->getExpired());
        $user->setLocked($response->getLocked());
        $this->userManager->updateUser($user);

        return $user;
    }
}
