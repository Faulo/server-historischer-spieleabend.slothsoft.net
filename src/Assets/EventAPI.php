<?php
declare(strict_types = 1);
namespace Slothsoft\Server\HistorischerSpieleabend\Assets;

use Slothsoft\Core\DOMHelper;
use Slothsoft\Farah\FarahUrl\FarahUrlArguments;
use Slothsoft\Farah\Module\Module;
use Slothsoft\Farah\Module\Asset\AssetInterface;
use Slothsoft\Farah\Module\Asset\ExecutableBuilderStrategy\ExecutableBuilderStrategyInterface;
use Slothsoft\Farah\Module\Executable\ExecutableStrategies;
use Slothsoft\Farah\Module\Executable\ResultBuilderStrategy\DOMWriterResultBuilder;

class EventAPI implements ExecutableBuilderStrategyInterface {

    public static string $indexPath = __DIR__ . '/../../assets/index.xml';

    public function buildExecutableStrategies(AssetInterface $context, FarahUrlArguments $args): ExecutableStrategies {
        $url = $context->createUrl()->withPath('/index');
        $writer = Module::resolveToDOMWriter($url);
        $result = new ExecutableStrategies(new DOMWriterResultBuilder($writer, 'index.xml'));

        $xpath = DOMHelper::loadXPath(DOMHelper::loadDocument('farah://slothsoft@farah/sites'));
        $eventId = $xpath->evaluate('string(//*[@current]/@name)');

        if (! $eventId) {
            return $result;
        }

        $document = $writer->toDocument();
        $event = $document->getElementById($eventId);

        if (! $event) {
            return $result;
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

        return $result;
    }
}

