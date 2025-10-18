<?php
declare(strict_types = 1);
namespace Slothsoft\Server\HistorischerSpieleabend\Assets;

use Slothsoft\Core\DOMHelper;
use Slothsoft\Core\IO\Writable\Delegates\DOMWriterFromElementDelegate;
use Slothsoft\Farah\FarahUrl\FarahUrlArguments;
use Slothsoft\Farah\Module\Asset\AssetInterface;
use Slothsoft\Farah\Module\Asset\ExecutableBuilderStrategy\ExecutableBuilderStrategyInterface;
use Slothsoft\Farah\Module\Executable\ExecutableStrategies;
use Slothsoft\Farah\Module\Executable\ResultBuilderStrategy\DOMWriterResultBuilder;
use DOMDocument;
use DOMElement;

class EventIDs implements ExecutableBuilderStrategyInterface {
    
    private const NS = 'http://schema.slothsoft.net/schema/historical-games-night';
    
    public function buildExecutableStrategies(AssetInterface $context, FarahUrlArguments $args): ExecutableStrategies {
        $indexUrl = $context->createUrl()->withPath('/index');
        $delegate = function (DOMDocument $target) use ($indexUrl): DOMElement {
            $root = $target->createElement('ids');
            
            $indexDocument = DOMHelper::loadDocument((string) $indexUrl);
            $subtracks = [];
            foreach ($indexDocument->getElementsByTagNameNS(self::NS, 'track') as $trackNode) {
                $trackId = $trackNode->getAttribute('id');
                $i = 1;
                foreach ($trackNode->getElementsByTagNameNS(self::NS, 'subtrack') as $subtrackNode) {
                    $key = $subtrackNode->getAttribute('id');
                    $id = sprintf('%s%d', $trackId, $i);
                    $subtracks[$key] = $id;
                    $i ++;
                }
            }
            $events = [];
            $i = 0;
            foreach ($indexDocument->getElementsByTagNameNS(self::NS, 'event') as $eventNode) {
                $name = $eventNode->getAttribute('theme');
                $track = $eventNode->getAttribute('track');
                $track = $subtracks[$track];
                if (! isset($events[$track])) {
                    $events[$track] = [];
                }
                
                if ($date = $eventNode->getAttribute('date')) {
                    $timestamp = strtotime($date);
                } else {
                    $timestamp = 365 * 3000 + $i;
                }
                
                $events[$track][$name] = isset($events[$track][$name]) ? min($events[$track][$name], $timestamp) : $timestamp;
                
                $i ++;
            }
            
            ksort($events);
            
            foreach ($events as $subtrackId => $subtrack) {
                asort($subtrack);
                
                $i = 1;
                foreach (array_keys($subtrack) as $name) {
                    $eventId = sprintf(sprintf('%s%02d', $subtrackId, $i));
                    $idNode = $target->createElement('id');
                    $idNode->setAttribute('name', (string) $name);
                    $idNode->setAttributeNS(DOMHelper::NS_XML, 'xml:id', $eventId);
                    $root->appendChild($idNode);
                    $i ++;
                }
            }
            return $root;
        };
        
        $writer = new DOMWriterFromElementDelegate($delegate);
        
        $result = new DOMWriterResultBuilder($writer, 'ids.xml');
        
        return new ExecutableStrategies($result);
    }
}

