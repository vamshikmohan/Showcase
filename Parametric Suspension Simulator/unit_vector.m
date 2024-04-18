function VectorB = unit_vector(VectorA)

    VectorB = VectorA/((sum(VectorA.*VectorA))^0.5);

end