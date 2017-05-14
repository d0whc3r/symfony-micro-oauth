<?php

namespace AppBundle\Command;

use Symfony\Bundle\FrameworkBundle\Command\ContainerAwareCommand;
use Symfony\Component\Console\Input\InputInterface;
use Symfony\Component\Console\Input\InputOption;
use Symfony\Component\Console\Output\OutputInterface;

class CreateClientCommand extends ContainerAwareCommand
{

    protected function configure()
    {
        $this
            ->setName('appbundle:oauth-server:client:create')
            ->setDescription('Creates a new client')
            ->addOption(
                'redirect-uri', null, InputOption::VALUE_REQUIRED | InputOption::VALUE_IS_ARRAY, 'Sets redirect uri for client. Use this option multiple times to set multiple redirect URIs.', null
            )
            ->addOption(
                'grant-type', null, InputOption::VALUE_REQUIRED | InputOption::VALUE_IS_ARRAY, 'Sets allowed grant type for client. Use this option multiple times to set multiple grant types..', null
            )
            ->addOption(
                'client_id', null, InputOption::VALUE_OPTIONAL, 'Set client_id, for development purpose', null
            )
            ->addOption(
                'secret_id', null, InputOption::VALUE_OPTIONAL, 'Set secret_id, for development purpose', null
            )
            ->setHelp(
                <<<EOT
                    The <info>%command.name%</info> command creates a new client.

<info>php %command.full_name% [--redirect-uri=...] [--grant-type=...]</info>

example:
- php app/console %command.name% --redirect-uri=http://localhost/api --grant-type=password
- php app/console %command.name% --redirect-uri=http://localhost/api --grant-type="authorization_code" --grant-type="password" --grant-type="refresh_token" --grant-type="token" --grant-type="client_credentials"

In dev environment:
- php app/console %command.name% --redirect-uri=http://localhost/api --grant-type=password --client_id=someclientid --secret_id=somesecretid

EOT
            );
    }

    protected function execute(InputInterface $input, OutputInterface $output)
    {
        $clientManager = $this->getContainer()->get('fos_oauth_server.client_manager.default');
        $client = $clientManager->createClient();
        $client->setRedirectUris($input->getOption('redirect-uri'));
        $client->setAllowedGrantTypes($input->getOption('grant-type'));
        if ($input->hasOption('client_id')) {
            $client->setRandomId($input->getOption('client_id'));
        }
        if ($input->hasOption('secret_id')) {
            $client->setSecret($input->getOption('secret_id'));
        }
        $clientManager->updateClient($client);
        $output->writeln(sprintf('Added a new client with public id <info>%s</info>, secret <info>%s</info>', $client->getPublicId(), $client->getSecret()));
    }

}
