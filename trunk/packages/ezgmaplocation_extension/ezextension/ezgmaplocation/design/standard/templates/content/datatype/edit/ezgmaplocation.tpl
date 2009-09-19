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
</div>

<div class="element">
{run-once}
<script src="http://maps.google.com/maps?file=api&amp;v=2&amp;key={ezini('SiteSettings','GMapsKey')}" type="text/javascript"></script>
<script type="text/javascript">
{literal}
    function eZGmapLocation_MapControl( attributeId, latLongAttributeBase )
    { 
        var mapid = 'ezgml-map-' + attributeId, latid  = 'ezcoa-' + latLongAttributeBase + '_latitude', longid = 'ezcoa-' + latLongAttributeBase + '_longitude';
        var geocoder = null, addressid = 'ezgml-address-' + attributeId;
    
        var showAddress = function()
        {
          var addrObj = document.getElementById( addressid );
          var address = addrObj.value;
          if ( geocoder )
          {
            geocoder.getLatLng(
              address,
              function( point )
              {
                if (!point)
                {
                  alert(address + " not found");
                }
                else
                {
                  map.setCenter(point, 13);
                  map.clearOverlays();
                  map.addOverlay( new GMarker(point) );
                  //map.panTo( point );
                  updateLatLngFields( point );
                }
              }
            );
          }
        };
        
        var updateLatLngFields = function( point )
        {
            document.getElementById(latid).value = point.lat();
            document.getElementById(longid).value = point.lng();
            document.getElementById( 'ezgml-restore-button-' + attributeId ).disabled = false;
        };

        var restoretLatLngFields = function()
        {
            document.getElementById( latid ).value     = document.getElementById('ezgml_hidden_latitude_' + attributeId ).value;
            document.getElementById( longid ).value    = document.getElementById('ezgml_hidden_longitude_' + attributeId ).value;
            document.getElementById( addressid ).value = document.getElementById('ezgml_hidden_address_' + attributeId ).value;
            if ( document.getElementById( latid ).value && document.getElementById( latid ).value != 0 )
            {
                var point = new GLatLng( document.getElementById( latid ).value, document.getElementById( longid ).value );
                //map.setCenter(point, 13);
                map.clearOverlays();
                map.addOverlay( new GMarker(point) );
                map.panTo( point );
            }
            document.getElementById( 'ezgml-restore-button-' + attributeId ).disabled = true;
            return false;
        };

        if (GBrowserIsCompatible())
        {
            var startPoint = null, zoom = 0;
            if ( document.getElementById( latid ).value && document.getElementById( latid ).value != 0 )
            {
                startPoint = new GLatLng( document.getElementById( latid ).value, document.getElementById( longid ).value );
                zoom = 13;
            }
            else
            {
                startPoint = new GLatLng(0,0);
            }
          
            var map = new GMap2( document.getElementById( mapid ) );
            map.addControl( new GSmallMapControl() );
            map.addControl( new GMapTypeControl() );
            map.setCenter( startPoint, zoom );
            map.addOverlay( new GMarker( startPoint ) );
            geocoder = new GClientGeocoder();
            GEvent.addListener( map, "click", function( newmarker, point )
            {
                map.clearOverlays();
                map.addOverlay( new GMarker( point ) );
                map.panTo( point );
                updateLatLngFields( point );
                document.getElementById( addressid ).value = '';
            });

            document.getElementById( 'ezgml-address-button-' + attributeId ).onclick = showAddress;
            document.getElementById( 'ezgml-restore-button-' + attributeId ).onclick = restoretLatLngFields;
        }
    }
{/literal}
</script>
{/run-once}

<script type="text/javascript">
<!--

if ( window.addEventListener )
    window.addEventListener('load', function(){ldelim} eZGmapLocation_MapControl( {$attribute.id}, "{if ne( $attribute_base, 'ContentObjectAttribute' )}{$attribute_base}-{/if}{$attribute.contentclassattribute_id}_{$attribute.contentclass_attribute_identifier}" ) {rdelim}, false);
else if ( window.attachEvent )
    window.attachEvent('onload', function(){ldelim} eZGmapLocation_MapControl( {$attribute.id}, "{if ne( $attribute_base, 'ContentObjectAttribute' )}{$attribute_base}-{/if}{$attribute.contentclassattribute_id}_{$attribute.contentclass_attribute_identifier}" ) {rdelim} );

-->
</script>

<div id="ezgml-map-{$attribute.id}" style="width: 500px; height: 280px;"></div>
    <input type="text" id="ezgml-address-{$attribute.id}" size="59" name="{$attribute_base}_data_gmaplocation_address_{$attribute.id}" value="{$attribute.content.address}"/>
    <input class="defaultbutton" type="button" id="ezgml-address-button-{$attribute.id}" value="{'Find address'|i18n('extension/ezgmaplocation/datatype')}"/>
    <input class="defaultbutton" type="button" id="ezgml-restore-button-{$attribute.id}" value="{'Restore'|i18n('extension/ezgmaplocation/datatype')}" onclick="javascript:void( null ); return false" disabled="disabled" />

    <input id="ezgml_hidden_address_{$attribute.id}" type="hidden" name="ezgml_hidden_address_{$attribute.id}" value="{$attribute.content.address}" disabled="disabled" />
    <input id="ezgml_hidden_latitude_{$attribute.id}" type="hidden" name="ezgml_hidden_latitude_{$attribute.id}" value="{$attribute.content.latitude}" disabled="disabled" />
    <input id="ezgml_hidden_longitude_{$attribute.id}" type="hidden" name="ezgml_hidden_longitude_{$attribute.id}" value="{$attribute.content.longitude}" disabled="disabled" />
</div>

<div class="break"></div>
</div>
