<?php
declare(strict_types = 1);
namespace Slothsoft\Server\HistorischerSpieleabend\Tests;

use Slothsoft\Farah\FarahUrl\FarahUrlAuthority;
use Slothsoft\FarahTesting\Module\AbstractModuleTest;

class AssetsModuleTest extends AbstractModuleTest {
    
    protected static function getManifestAuthority(): FarahUrlAuthority {
        return FarahUrlAuthority::createFromVendorAndModule('slothsoft', 'historischer-spieleabend.slothsoft.net');
    }
}