<?php
declare(strict_types = 1);
namespace Slothsoft\Server\HistorischerSpieleabend\Tests;

use Slothsoft\Farah\Configuration\AssetConfigurationField;
use Slothsoft\FarahTesting\Module\AbstractSitemapTest;
use Slothsoft\Farah\Module\Asset\AssetInterface;

class SitemapTest extends AbstractSitemapTest {

    protected static function loadSitesAsset(): AssetInterface {
        return (new AssetConfigurationField('farah://slothsoft@historischer-spieleabend.slothsoft.net/sitemap'))->getValue();
    }
}