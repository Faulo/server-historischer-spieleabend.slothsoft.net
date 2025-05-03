<?php
declare(strict_types = 1);
namespace Slothsoft\Server\HistorischerSpieleabend\Assets;

use Slothsoft\Core\DOMHelper;
use Slothsoft\Farah\FarahUrl\FarahUrlArguments;
use Slothsoft\Farah\Module\Module;
use Slothsoft\Farah\Module\Asset\AssetInterface;
use Slothsoft\Farah\Module\Asset\ExecutableBuilderStrategy\ExecutableBuilderStrategyInterface;
use Slothsoft\Farah\Module\Executable\ExecutableStrategies;
use Slothsoft\Farah\Module\Executable\ResultBuilderStrategy\NullResultBuilder;

class EventAPI implements ExecutableBuilderStrategyInterface {

    public static string $indexPath = __DIR__ . '/../../assets/index.xml';

    public function buildExecutableStrategies(AssetInterface $context, FarahUrlArguments $args): ExecutableStrategies {
        $xpath = DOMHelper::loadXPath(DOMHelper::loadDocument('farah://slothsoft@farah/sites'));
        $eventId = $xpath->evaluate('string(//*[@current]/@name)');

        if (! $eventId) {
            return new ExecutableStrategies(new NullResultBuilder());
        }

        $url = $context->createUrl()->withPath('/index');
        $document = Module::resolveToResult($url)->lookupDOMWriter()->toDocument();
        $event = $document->getElementById($eventId);

        if (! $event) {
            return new ExecutableStrategies(new NullResultBuilder());
        }

        $hasChanged = false;
        foreach ($args->get('event', []) as $key => $value) {
            if (is_string($value) and $event->getAttribute($key) !== $value) {
                $event->setAttribute($key, $value);
                $hasChanged = true;
            }
        }

        if ($hasChanged) {
            $document->save(self::$indexPath);
        }

        return new ExecutableStrategies(new NullResultBuilder());
    }
}

