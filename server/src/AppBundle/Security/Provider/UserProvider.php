<?php

namespace AppBundle\Security\Provider;

use Doctrine\ORM\EntityManager;
use Symfony\Component\HttpKernel\Exception\HttpException;
use Symfony\Component\Security\Core\Exception\UsernameNotFoundException;
use Symfony\Component\Security\Core\User\UserInterface;
use Symfony\Component\Security\Core\User\UserProviderInterface;
use Symfony\Component\Serializer\Exception\UnsupportedException;

class UserProvider implements UserProviderInterface
{
    protected $class;

    protected $userRepository;

    public function __construct(EntityManager $entityManager, $class)
    {
        $this->class = $class;
        $this->userRepository = $entityManager->getRepository($class);
    }

    public function loadUserByUsername($username)
    {
        $user = $this->userRepository->findOneBy(['username' => $username]);
        if (null === $user) {
            $message = sprintf(
                'Unable to find an active User object identified by "%s"',
                $username
            );
//            throw new UsernameNotFoundException($message, 0, 'failed');
            throw new UsernameNotFoundException($message);
//            throw new HttpException(401, $message);
        }
        return $user;
    }

    public function refreshUser(UserInterface $user)
    {
        $class = get_class($user);
        if (false == $this->supportsClass($class)) {
            throw new UnsupportedException(
                sprintf(
                    'Instances of "%s" are not supported',
                    $class
                )
            );
        }
        return $this->userRepository->find($user->getId());
    }

    public function supportsClass($class)
    {
        return $this->class === $class
            || is_subclass_of($class, $this->class);

    }
}