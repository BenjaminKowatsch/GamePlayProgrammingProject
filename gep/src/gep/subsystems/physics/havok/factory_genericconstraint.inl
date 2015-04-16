#include <Physics2012/Dynamics/Constraint/ConstraintKit/hkpGenericConstraintData.h>
#include <Physics2012/Dynamics/Constraint/ConstraintKit/hkpGenericConstraintParameters.h>
#include <Physics2012/Dynamics/Constraint/ConstraintKit/hkpConstraintConstructionKit.h>

static hkpConstraintInstance* createGenericConstraint(ScriptTableWrapper& scriptTable)
{
    auto L = scriptTable.getState();

    auto pA = getRigidBody(scriptTable, "A", RigidBodyRetrievalBehavior::RaiseError);
    auto pB = getRigidBody(scriptTable, "B", RigidBodyRetrievalBehavior::UseNullptrAsFallback);

    auto pData = new hkpGenericConstraintData();

    hkpConstraintConstructionKit kit;
    kit.begin(pData);
    {
        // Pivot of A is necessary.
        kit.setPivotA(getVec4(scriptTable, "pivotA"));

        gep::vec3 data(0, 0, 0);
        if(pB)
        {
            scriptTable.tryGet("pivotB", data);
        }
        kit.setPivotB(conversion::hk::to(data));

        ScriptTableWrapper linear;
        if(scriptTable.tryGet("linear", linear))
        {
            const int axisId = 0;
            bool any = false;

            if(linear.tryGet("dofA", data))
            {
                kit.setLinearDofA(conversion::hk::to(data), axisId);
                any = true;
            }

            if(linear.tryGet("dofB", data))
            {
                kit.setLinearDofB(conversion::hk::to(data), axisId);
                any = true;
            }

            if(linear.tryGet("dofWorld", data))
            {
                kit.setLinearDofWorld(conversion::hk::to(data), axisId);
                any = true;
            }

            if(any)
            {
                kit.constrainLinearDof(axisId);
            }
        }

        ScriptTableWrapper angular;
        if(scriptTable.tryGet("angular", angular))
        {
            const int axisId = 0;
            bool any = false;
            bool anyWithAxis = false;
            hkMatrix3 temp;
            bool inBodyFrame;

            if (angular.tryGet("basisA", data))
            {
                temp.setCols(hkVector4(data.x, 0,      0),
                             hkVector4(0,      data.y, 0),
                             hkVector4(0,      0,      data.z));
                kit.setAngularBasisA(temp);
                any = true;
            }

            if (angular.tryGet("basisABodyFrame", inBodyFrame) && inBodyFrame)
            {
                kit.setAngularBasisABodyFrame();
                any = true;
            }

            if (angular.tryGet("basisB", data))
            {
                temp.setCols(hkVector4(data.x, 0,      0),
                             hkVector4(0,      data.y, 0),
                             hkVector4(0,      0,      data.z));
                kit.setAngularBasisB(temp);
                any = true;
            }

            if (angular.tryGet("basisBBodyFrame", inBodyFrame) && inBodyFrame)
            {
                kit.setAngularBasisBBodyFrame();
                any = true;
            }

            // TODO Implement the other functions, like setAngularLimit
            //if (angular.tryGet("angularLimit", otherTableContainingMinMax))
            //{
            //    kit.setAngularLimit(...);
            //    anyWithAxis = true;
            //}

            if(anyWithAxis)
            {
                kit.constrainToAngularDof(axisId);
            }

            if(any)
            {
                kit.constrainAllAngularDof();
            }
        }

        //hkMatrix3 a;
        //a.setCols(hkVector4(1, 0, 0),
        //          hkVector4(0, 1, 0),
        //          hkVector4(0, 0, 0));
        //kit.setAngularBasisA(a);
        //kit.setAngularBasisB(a);
        //kit.setAngularBasisBBodyFrame();
        //kit.constrainAllAngularDof();
        //kit.constrainToAngularDof(axisId);
    }
    kit.end();

    auto pConstraint = new hkpConstraintInstance(pA, pB, pData);
    pData->removeReference();

    return pConstraint;
}
