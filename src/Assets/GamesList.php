<?php
declare(strict_types = 1);
namespace Slothsoft\Server\HistorischerSpieleabend\Assets;

use Slothsoft\Core\DOMHelper;
use Slothsoft\Core\Storage;
use Slothsoft\Core\IO\Writable\Delegates\DOMWriterFromElementDelegate;
use Slothsoft\Farah\FarahUrl\FarahUrlArguments;
use Slothsoft\Farah\Module\Module;
use Slothsoft\Farah\Module\Asset\AssetInterface;
use Slothsoft\Farah\Module\Asset\ExecutableBuilderStrategy\ExecutableBuilderStrategyInterface;
use Slothsoft\Farah\Module\Executable\ExecutableStrategies;
use Slothsoft\Farah\Module\Executable\ResultBuilderStrategy\DOMWriterResultBuilder;
use DOMDocument;
use DOMElement;

class GamesList implements ExecutableBuilderStrategyInterface {

    private array $games = [
        'Dune II' => 'Dune II: The Building of a Dynasty',
        'Pokémon Gold and Silver' => 'Pokémon Goldene und Silberne Edition',
        'Pokémon Red and Blue' => 'Pokémon Rote und Blaue Edition',
        'Civilization' => 'Sid Meier\'s Civilization',
        'Civilization II' => 'Sid Meier\'s Civilization II',
        'Civilization III' => 'Sid Meier\'s Civilization III',
        'Civilization IV' => 'Sid Meier\'s Civilization IV',
        'Civilization V' => 'Sid Meier\'s Civilization V',
        'Civilization VI' => 'Sid Meier\'s Civilization VI',
    ];

    private array $platforms = [
        'SuperNES' => 'SNES',
        'PC' => 'Windows',
        'Nintendo3DS' => '3DS',
        'PlayStation' => 'PS1',
        'GameCube' => 'GCN',
        'Nintendo64' => 'N64',
        'GameBoy' => 'GB',
        'GameBoyColor' => 'GBC',
        'Atari8-bit' => 'Atari800',
        'Commodore64' => 'C64',
        'NintendoSwitch' => 'Switch',
        'GameBoyAdvance' => 'GBA'
    ];

    public function buildExecutableStrategies(AssetInterface $context, FarahUrlArguments $args): ExecutableStrategies {
        $url = $context->createUrl()->withPath('/index');
        $writer = Module::resolveToDOMWriter($url);
        $index = DOMHelper::loadXPath($writer->toDocument());

        $delegate = function (DOMDocument $target) use ($index, $args): DOMElement {
            $ns = 'http://schema.slothsoft.net/schema/historical-games-night';

            $done = $target->createElementNS($ns, 'event');
            $done->setAttributeNS(DOMHelper::NS_XML, 'id', 'MIS806');
            $done->setAttribute('theme', 'List of video games considered the best (Done)');
            $done->setAttribute('type', 'special');

            $todo = $target->createElementNS($ns, 'event');
            $todo->setAttributeNS(DOMHelper::NS_XML, 'id', 'MIS807');
            $todo->setAttribute('theme', 'List of video games considered the best (TODO)');
            $todo->setAttribute('type', 'special');

            if ($url = $args->get('url', 'https://en.wikipedia.org/wiki/List_of_video_games_considered_the_best')) {

                if ($document = Storage::loadExternalDocument($url)) {

                    $xpath = DOMHelper::loadXPath($document);

                    foreach ($xpath->evaluate('//table[.//th[normalize-space(.) = "Game"]]//tr') as $row) {
                        $year = $xpath->evaluate('normalize-space(th[@scope="row"] | td/preceding::th[@scope="rowgroup"][1])', $row);
                        if ($year) {
                            $name = $xpath->evaluate('normalize-space(td[1])', $row);
                            if (isset($this->games['name'])) {
                                $name = $this->games['name'];
                            }

                            $query = sprintf('//*[@name = "%s" and @from = "%s"]', $name, $year);
                            $game = $index->evaluate($query)->item(0);
                            if ($game) {
                                $done->appendChild($target->importNode($game, true));
                            } else {

                                $dev = $xpath->evaluate('normalize-space(td[3])', $row);
                                $platform = $xpath->evaluate('normalize-space(td[4])', $row);

                                $platforms = explode(',', $platform);
                                foreach ($platforms as &$platform) {
                                    $platform = str_replace(' ', '', $platform);
                                    if (isset($this->platforms[$platform])) {
                                        $platform = $this->platforms[$platform];
                                    }
                                }
                                unset($platform);
                                $platform = implode('/', $platforms);

                                $game = $target->createElementNS($ns, 'game');
                                $game->setAttribute('name', $name);
                                $game->setAttribute('from', $year);
                                $game->setAttribute('by', $dev);
                                $game->setAttribute('on', $platform);
                                $game->setAttribute('country', '');
                                $todo->appendChild($game);
                            }
                        }
                    }
                }
            }

            $root = $target->createElementNS($ns, 'unsorted');
            $root->appendChild($done);
            $root->appendChild($todo);

            return $root;
        };

        $writer = new DOMWriterFromElementDelegate($delegate);

        $result = new DOMWriterResultBuilder($writer, 'games.xml');

        return new ExecutableStrategies($result);
    }
}

