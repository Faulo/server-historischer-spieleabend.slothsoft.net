<?php
declare(strict_types = 1);
namespace Slothsoft\Server\HistorischerSpieleabend\Assets;

use Slothsoft\Core\DOMHelper;
use Slothsoft\Core\Storage;
use Slothsoft\Core\Calendar\Seconds;
use Slothsoft\Core\IO\Writable\Delegates\DOMWriterFromElementDelegate;
use Slothsoft\Farah\FarahUrl\FarahUrlArguments;
use Slothsoft\Farah\Module\Module;
use Slothsoft\Farah\Module\Asset\AssetInterface;
use Slothsoft\Farah\Module\Asset\ExecutableBuilderStrategy\ExecutableBuilderStrategyInterface;
use Slothsoft\Farah\Module\Executable\ExecutableStrategies;
use Slothsoft\Farah\Module\Executable\ResultBuilderStrategy\DOMWriterResultBuilder;
use DOMDocument;
use DOMElement;
use DOMXPath;

class GamesList implements ExecutableBuilderStrategyInterface {
    
    private const NS = 'http://schema.slothsoft.net/schema/historical-games-night';
    
    private array $games = [
        'Dune II' => 'Dune II: The Building of a Dynasty',
        'Pokémon Gold and Silver' => 'Pokémon Goldene und Silberne Edition',
        'Pokémon Red and Blue' => 'Pokémon Rote und Blaue Edition',
        'Civilization' => 'Sid Meier\'s Civilization',
        'Civilization II' => 'Sid Meier\'s Civilization II',
        'Civilization III' => 'Sid Meier\'s Civilization III',
        'Civilization IV' => 'Sid Meier\'s Civilization IV',
        'Civilization V' => 'Sid Meier\'s Civilization V',
        'Civilization VI' => 'Sid Meier\'s Civilization VI'
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
    
    private function getIndex(AssetInterface $context): DOMXPath {
        $url = $context->createUrl()
            ->withPath('/index')
            ->withFragment('xml');
        $writer = Module::resolveToDOMWriter($url);
        $index = DOMHelper::loadXPath($writer->toDocument());
        return $index;
    }
    
    public function buildExecutableStrategies(AssetInterface $context, FarahUrlArguments $args): ExecutableStrategies {
        $index = $this->getIndex($context);
        
        $delegate = function (DOMDocument $target) use ($index, $args): DOMElement {
            $root = $target->createElementNS(self::NS, 'events');
            $root->setAttribute('version', '2.0');
            
            if ($url = $args->get('url', '')) {
                if ($document = Storage::loadExternalDocument($url, Seconds::MONTH)) {
                    $xpath = DOMHelper::loadXPath($document);
                    $h1 = $xpath->evaluate('normalize-space(//h1)');
                    
                    $read = $target->createElementNS(self::NS, 'read');
                    $read->setAttribute('href', $url);
                    $read->setAttribute('name', $h1);
                    $read->setAttribute('released', date('Y'));
                    $read->setAttribute('by', 'Wikipedia');
                    
                    $done = $target->createElementNS(self::NS, 'event');
                    $done->setAttribute('theme', "$h1 (Done)");
                    $done->setAttribute('type', 'special');
                    $done->setAttribute('track', 'MIS-Wiki');
                    
                    $todo = $target->createElementNS(self::NS, 'event');
                    $todo->setAttribute('theme', "$h1 (TODO)");
                    $todo->setAttribute('type', 'special');
                    $todo->setAttribute('track', 'MIS-Wiki');
                    foreach ($xpath->evaluate('//table[.//th[normalize-space(.) = "Game"]]//tr') as $row) {
                        $year = $xpath->evaluate('normalize-space(th[@scope="row"])', $row);
                        if (! $year) {
                            $year = $xpath->evaluate('normalize-space(td/preceding::th[@scope="rowgroup"][1])', $row);
                        }
                        
                        if ($year) {
                            $name = $xpath->evaluate('normalize-space(td[1])', $row);
                            if (isset($this->games[$name])) {
                                $name = $this->games[$name];
                            }
                            
                            $query = sprintf('//*[@name = "%s" and @from = "%s"]', $name, $year);
                            $game = $index->evaluate($query)->item(0);
                            if ($game) {
                                $done->appendChild($target->importNode($game, true));
                            } else {
                                
                                $dev = $xpath->evaluate('normalize-space(td[3])', $row);
                                $platform = $xpath->evaluate('normalize-space(td[last()]/preceding-sibling::td[1])', $row);
                                
                                $platforms = explode(',', $platform);
                                foreach ($platforms as &$platform) {
                                    $platform = str_replace(' ', '', $platform);
                                    if (isset($this->platforms[$platform])) {
                                        $platform = $this->platforms[$platform];
                                    }
                                }
                                unset($platform);
                                $platform = $platforms[0];
                                
                                $game = $this->createGame($target, $name, $year, $dev, $platform);
                                $todo->appendChild($game);
                            }
                        }
                    }
                    
                    $done->appendChild($read->cloneNode(true));
                    $todo->appendChild($read->cloneNode(true));
                    
                    $root->appendChild($done);
                    $root->appendChild($todo);
                }
            }
            return $root;
        };
        
        $writer = new DOMWriterFromElementDelegate($delegate);
        
        $result = new DOMWriterResultBuilder($writer, 'games.xml');
        
        return new ExecutableStrategies($result);
    }
    
    private function createGame(DOMDocument $target, string $name, string $year, string $dev, string $platform): DOMElement {
        $game = $target->createElementNS(self::NS, 'game');
        $game->setAttribute('name', $name);
        $game->setAttribute('released', $year);
        $game->setAttribute('by', $dev);
        $game->setAttribute('on', $platform);
        $game->setAttribute('country', '?');
        return $game;
    }
}

