{* DO NOT EDIT THIS FILE! Use an override template instead. *}
{if is_set( $attribute_base )|not}
  {def $attribute_base = 'ContentObjectAttribute'}
{/if}
<div class="block">

<div class="element">
  <div class="block">
    <label>{'Latitude'|i18n('extension/ezgmaplocation/datatype')}:</label>
    <input id="ezcoa-{if ne( $attribute_base, 'ContentObjectAttribute' )}{$attribute_base}-{/if}{$attribute.contentclassattribute_id}_{$attribute.contentclass_attribute_identifier}_latitude" class="box ezcc-{$attribute.object.content_class.identifier} ezcca-{$attribute.object.content_class.identifier}_{$attribute.contentclass_attribute_identifier}" type="text" name="{$attribute_base}_data_gmaplocation_latitude_{$attribute.id}" value="{$attribute.content.latitude}" />
  </div>
  
  <div class="block">
    <label>{'Longitude'|i18n('extension/ezgmaplocation/datatype')}:</label>
    <input id="ezcoa-{if ne( $attribute_base, 'ContentObjectAttribute' )}{$attribute_base}-{/if}{$attribute.contentclassattribute_id}_{$attribute.contentclass_attribute_identifier}_longitude" class="box ezcc-{$attribute.object.content_class.identifier} ezcca-{$attribute.object.content_class.identifier}_{$attribute.contentclass_attribute_identifier}" type="text" name="{$attribute_base}_data_gmaplocation_longitude_{$attribute.id}" value="{$attribute.content.longitude}" />
  </div>

  <div class="block">
    <label>{'Update Location'|i18n('extension/ezgmaplocation/datatype')}:</label>
    <input type="button" id="ezgml-update-button-{$attribute.id}" value="{'Update values'|i18n('extension/ezgmaplocation/datatype')}" onclick="javascript:void( null ); return false" />
  </div>
</div>

<div class="element">
{run-once}
<script src="http://maps.google.com/maps?file=api&amp;v=2.x&amp;key={ezini('SiteSettings','GMapsKey')}" type="text/javascript"></script>
<script type="text/javascript">
    function eZGmapLocation_MapControl( attributeId )
    {ldelim} 
        var mapid = 'ezgml-map-' + attributeId, addressid = 'ezgml-address-' + attributeId;
        var latid = 'ezcoa-{if ne( $attribute_base, 'ContentObjectAttribute' )}{$attribute_base}-{/if}{$attribute.contentclassattribute_id}_{$attribute.contentclass_attribute_identifier}_latitude';
        var longid = 'ezcoa-{if ne( $attribute_base, 'ContentObjectAttribute' )}{$attribute_base}-{/if}{$attribute.contentclassattribute_id}_{$attribute.contentclass_attribute_identifier}_longitude';
        {literal}
        
        var map = null, geocoder = null, gmapExistingOnload = null, marker = null, me = this;
    
        var showAddress = function()
        {
          var addrObj = document.getElementById(addressid);
          var address = addrObj.value;
          if (geocoder) {
            geocoder.getLatLng(
              address,
              function(point) {
                if (!point) {
                  alert(address + " not found");
                } else {
                  map.setCenter(point, 13);
                  marker = new GMarker(point);
                  map.addOverlay(marker);
                  // updateLatLngFields(point);
                }
              }
            );
          }
        };
        
        var updateLatLngFields = function( point )
        {
            document.getElementById(latid).value = point.lat(); 
            document.getElementById(longid).value = point.lng(); 
        };

        var updateLatLngFieldsWrapper = function()
        {
            var point = new GLatLng( map.getCenter().lat(), map.getCenter().lng() );
            updateLatLngFields( point );
        };    

        if (GBrowserIsCompatible())
        {
            var startPoint = null, zoom = 0;
            if (document.getElementById(latid).value)
            {
                startPoint = new GLatLng( document.getElementById(latid).value, document.getElementById(longid).value );
                zoom = 13;
            }
            else
            {
                startPoint = new GLatLng(0,0);
            }
          
            map = new GMap2(document.getElementById(mapid));
            map.addControl(new GSmallMapControl());
            map.addControl(new GMapTypeControl());
            map.setCenter(startPoint, zoom);
            map.addOverlay(new GMarker(startPoint));
            geocoder = new GClientGeocoder();
            GEvent.addListener(map, "click", function( newmarker, point )
            {
                map.clearOverlays();
                map.addOverlay( new GMarker( point ) );
                map.panTo(point);
                // updateLatLngFields(point);
                document.getElementById( addressid ).value= '';
            });

            document.getElementById( 'ezgml-address-button-' + attributeId ).onclick = showAddress;
            document.getElementById( 'ezgml-update-button-' + attributeId ).onclick = updateLatLngFieldsWrapper;
        }
    }
{/literal}
</script>
{/run-once}

<script type="text/javascript">
<!--

if ( window.addEventListener )
    window.addEventListener('load', function(){ldelim} eZGmapLocation_MapControl( {$attribute.id} ) {rdelim}, false);
else if ( window.attachEvent )
    window.attachEvent('onload', function(){ldelim} eZGmapLocation_MapControl( {$attribute.id} ) {rdelim} );

-->
</script>

<div id="ezgml-map-{$attribute.id}" style="width: 400px; height: 280px;"></div>
    <input type="text" id="ezgml-address-{$attribute.id}" size="54" name="{$attribute_base}_data_gmaplocation_address_{$attribute.id}" value="{$attribute.content.address}"/>
    <input type="button" id="ezgml-address-button-{$attribute.id}" value="Find Address"/>
</div>


<div class="break"></div>
</div>
